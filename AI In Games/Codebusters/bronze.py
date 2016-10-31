import sys
import math
from queue import *
import numpy as np
import copy
import random


SIZE_X = None
SIZE_Y = None
GRID_SIZE = None 
TURN = None
STUN_COOLDOWN = None
BASE_RADIUS = None
MOVE_DIST = None
GHOST_MOVE_DIST = None
GHOST_HP = None
VISION_RANGE = None
ACTION_RANGE = None
BASE = None
ENEMY_BASE = None
BUSTER_COUNT = None
BUST_MIN_DIST = None
GHOST_COUNT = None
TEAM_ID = None
ENEMY_TEAM_ID = None
GHOST_ID = None
INF = None
DEBUG = None

grid = None


class Buster:

    def __init__ (self, id):
        self.id = id
        self.pos = (0,0)
        self.stunned = False
        self.usedRadar = False
        self.lastStun = 0
        self.ghostBusted = None
        self.ghost = None
        self.commandToExecute = None
        self.lastSeen = 0

    def moveTo(self, point):
        self.commandToExecute = "MOVE %d %d" % (point[0], point[1])
        return True

    def bust(self, ghost):
        self.commandToExecute = "BUST %d" % ghost.id
        return True

    def stun(self, buster):
        self.commandToExecute = "STUN %d" % buster.id
        self.lastStun = TURN
        #Załóżmy ze juz jest stunned zeby inny buster go nie zestunowal
        buster.stunned = True
        return True

    def release(self):
        self.commandToExecute = "RELEASE"
        return True

    def useRadar(self):
        self.usedRadar = True
        self.commandToExecute = "RADAR"
        return True

    def canUseStun(self):
        return TURN - self.lastStun > STUN_COOLDOWN or self.lastStun == 0

    def couldHaveUsedStun(self):
        return (TURN-1) - self.lastStun > STUN_COOLDOWN or self.lastStun == 0

    def isCarryingAGhost(self):
        return not self.ghost is None

    def isPosInSight(self, pos):
        return distance(self.pos, pos) <= VISION_RANGE

    def isPosInRange(self, pos):
        return distance(self.pos, pos) <= ACTION_RANGE

    def canBust(self, ghost):
        return BUST_MIN_DIST < distance(self.pos, ghost.pos) <= ACTION_RANGE 

    def isInBase(self):
        return distance(self.pos, BASE) <= BASE_RADIUS

    def goToBase(self):
        base = pairToNpVec(BASE)
        buster = pairToNpVec(self.pos)
        normalized = (buster - base) / np.linalg.norm(buster - base)
        target = (BASE_RADIUS - 2) * normalized + base
        return self.moveTo(target.astype(np.int64))

    def goToGhost(self, ghost):
        buster = pairToNpVec(self.pos)
        gpos = pairToNpVec(ghost.pos)
        toGhost = gpos - buster
        distanceToGhost = np.linalg.norm(toGhost) 
        normalized = toGhost / distanceToGhost

        if distanceToGhost > VISION_RANGE:
            return self.moveTo(ghost.pos)
        elif distanceToGhost > ACTION_RANGE:
            #Get 'slightly' in ACTION_RANGE
            target = buster + normalized * ((distanceToGhost - ACTION_RANGE) + 50 + GHOST_MOVE_DIST)
            return self.moveTo(target.astype(np.int64))
        else: #We are too close!
            #Let's just go towards base but not too far away
            base = pairToNpVec(BASE)
            toBase = base - buster
            normalized = toBase / np.linalg.norm(toBase)
            moveDist = MOVE_DIST
            if distanceToGhost >= ACTION_RANGE - GHOST_MOVE_DIST - MOVE_DIST:
                moveDist = ACTION_RANGE - GHOST_MOVE_DIST - MOVE_DIST
            target = buster + normalized * moveDist
            return self.moveTo(target.astype(np.int64))

    def explore(self):
        square = grid.getSquareFromPos(self.pos)
        group = tuple(grid.voronoi[square[0]][square[1]])
        candidateSquares = grid.bestSquares[group][2]
        chosenSquare = candidateSquares[random.randrange(0,len(candidateSquares))]
        return self.moveTo(grid.getMiddleOfSquare(chosenSquare))

    def selectOptimalGhost(self):
        square = grid.getSquareFromPos(self.pos)
        group = tuple(grid.voronoi[square[0]][square[1]])
        ghostsInMyArea = []

        for ghostId, ghost in Blackboard.ghosts.items():
            ghostSquare = grid.getSquareFromPos(ghost.pos)
            if tuple(grid.voronoi[ghostSquare[0]][ghostSquare[1]]) == group:
                ghostsInMyArea.append(ghost)
        allGhostsClose = list(Blackboard.ghosts.values())
        allGhostsClose = [gh for gh in allGhostsClose if distance(gh.pos, self.pos) <= 2*VISION_RANGE] 

        if len(ghostsInMyArea) > 0:
            ghostsInMyArea.sort(key=lambda gh: self.estimateRoundsToCapture(gh))
            Blackboard.selectedGhost = ghostsInMyArea[0]
            return True
        elif len(allGhostsClose) > 0:
            allGhostsClose.sort(key=lambda gh: self.estimateRoundsToCapture(gh))
            Blackboard.selectedGhost = allGhostsClose[0]
            return True
        return False


    def estimateRoundsToCapture(self, ghost):
        dist = distance(self.pos, ghost.pos)

        #Getting to the ghost:
        roundsToReach = 0
        if dist < BUST_MIN_DIST:
            roundsToReach = 1
        elif dist > ACTION_RANGE:
            roundsToReach = math.ceil((dist - ACTION_RANGE // 2) / MOVE_DIST)
        if ghost.bustersAttempting > 0 and roundsToReach > math.ceil(ghost.hp/ghost.bustersAttempting):
            return INF

        #Busting the ghost:
        roundsToBust = max(1, math.ceil((ghost.hp - ghost.bustersAttempting * roundsToReach) / (ghost.bustersAttempting+1)))

        #Returning to the base:
        ghostVec = pairToNpVec(ghost.pos)
        base = pairToNpVec(BASE)
        ghostToBase = base - ghostVec
        dist = np.linalg.norm(ghostToBase)
        dist = max(0, dist - ACTION_RANGE // 2)
        roundsToReturn = math.ceil(dist / MOVE_DIST)

        return roundsToReach + roundsToBust + roundsToReturn

    def enemyInRange(self):
        for enemyId, enemy in Blackboard.enemies.items():
            if self.isPosInRange(enemy.pos) and enemy.lastSeen == TURN and not enemy.stunned:
                Blackboard.selectedEnemy = enemy
                return True
        return False

    def stunTheEnemy(self):
        return self.stun(Blackboard.selectedEnemy)

    def noOperation(self):
        self.commandToExecute = "MOVE %d %d" % (BASE[0], BASE[1])
        return True

    def isBustingAGhost(self):
        return self.ghostBusted != None

    def canCatch(self, enemy):
        return self.canCatchStartingFrom(self.pos, enemy)

    def canCatchStartingFrom(self, startPos, enemy):
        #a - pozycja moja poczatkowa
        #b - pozycja przeciwnika
        #toBaseA - znormalizowany wektor wskazujacy kierunek do bazy od mojej pozycji
        #toBaseB - to samo tylko od pozycji wroga
        a = pairToNpVec(startPos)
        b = pairToNpVec(enemy.pos)
        enemyBase = pairToNpVec(ENEMY_BASE)
        toBaseA = (enemyBase - a)
        toBaseA = toBaseA / np.linalg.norm(toBaseA)
        toBaseB = (enemyBase - b)
        toBaseB = toBaseB / np.linalg.norm(toBaseB)

        #Nierówność kiedy jestem w zasięgu do stuna:
        #p*t^2 + q*t + r <= 0
        p = (MOVE_DIST * distance(toBaseA, toBaseB))**2
        q = 2.*MOVE_DIST * scalarProd(a - b, toBaseA - toBaseB)
        r = distance(a,b)**2 - ACTION_RANGE**2
        if q**2 - 4*p*r < 0:
            return False
        delta = math.sqrt(q**2 - 4*p*r)
        RES1 = (math.ceil((-q-delta)/(2*p)), math.floor((-q+delta)/(2*p)))

        #Nierówność kiedy przeciwnik jest poza bazą:
        #p*t^2 + q*t + r > 0
        p = MOVE_DIST**2 * scalarProd(toBaseB, toBaseB)
        q = 2.*MOVE_DIST * scalarProd(toBaseB, b - enemyBase)
        r = distance(b, enemyBase)**2 - BASE_RADIUS**2
        if q**2 - 4*p*r < 0:
            return False
        delta = math.sqrt(q**2 - 4*p*r)
        RES2 = (-1,math.floor((-q-delta-1)/(2*p)))

        if RES2[1] < RES1[0]:
            return False

        RES = (RES1[0], min(RES2[1], RES1[1]))
        #Now I know the interval of time when the buster will be in range to stun the enemy
        #Can the buster stun the enemy before or at the same time when he stuns the buster? 
        #If enemy has stun fster
        if (enemy.lastStun < self.lastStun and self.lastStun + STUN_COOLDOWN + 1 > RES[0]) or (self.lastStun != 0 and self.lastStun + STUN_COOLDOWN + 1 > RES[1]):
            return False
        return True

    def goToEnemyBase(self):
        return self.moveTo(ENEMY_BASE)

    def goToEnemy(self, enemy):
        buster = pairToNpVec(self.pos)
        epos = pairToNpVec(enemy.pos)
        toEnemy = epos - buster
        distanceToEnemy = np.linalg.norm(toEnemy) 
        normalized = toEnemy / distanceToEnemy

        if distanceToEnemy > VISION_RANGE:
            return self.moveTo(enemy.pos)
        else: # VISION_RANGE >= distanceToEnemy > ACTION_RANGE:
            target = buster + normalized * (distanceToEnemy - ACTION_RANGE + 5)
            return self.moveTo(target.astype(np.int64))

    def canStopTheEnemyBeforeBust(self):
        enemy = Blackboard.selectedEnemy
        ghost = enemy.ghostBusted
        roundsToBust = 10
        if ghost.id in Blackboard.ghosts:
            if ghost.bustersAttempting == 0:
                ghost.bustersAttempting += 1
            roundsToBust = ghost.hp / ghost.bustersAttempting
            if ghost.hp == 0 and ghost.bustersAttempting > 1:
                roundsToBust = INF

        roundsToStun = math.ceil((distance(self.pos, enemy.pos) - ACTION_RANGE + 10) / MOVE_DIST) + 1
        return roundsToBust >= roundsToStun and (roundsToBust == INF or self.lastStun == 0 or 
                self.lastStun + STUN_COOLDOWN + 1 <= TURN + roundsToStun or self.lastStun <= enemy.lastStun)

    def canCatchAfterBust(self, enemy):
        enemy = Blackboard.selectedEnemy
        ghost = enemy.ghostBusted
        roundsToBust = 10
        if ghost.id in Blackboard.ghosts:
            if ghost.bustersAttempting == 0:
                ghost.bustersAttempting += 1
            roundsToBust = ghost.hp / ghost.bustersAttempting

        enemyBase = pairToNpVec(ENEMY_BASE)
        myPos = pairToNpVec(self.pos)
        toBase = enemyBase - myPos / np.linalg.norm(enemyBase - myPos)
        startChasePos = myPos + MOVE_DIST * roundsToBust * toBase
        return self.canCatchStartingFrom(startChasePos, enemy)

    def smartGoToStopTheEnemy(self):
        return self.goToEnemyBase()


class Ghost:

    def __init__ (self, id):
        self.id = id
        self.pos = (0,0)
        self.hp = GHOST_HP
        self.lastSeen = 0
        self.bustersAttempting = 0 

class Grid:

    def __init__ (self):
        self.size_x = SIZE_X // GRID_SIZE
        self.size_y = SIZE_Y // GRID_SIZE
        self.grid = [[0 for y in range(self.size_y)] for x in range(self.size_x)]
        self.voronoi = [[[] for y in range(self.size_y)] for x in range(self.size_x)]
        self.bestSquares = {}

    def update(self):
        dist = [[INF for y in range(self.size_y)] for x in range(self.size_x)]
        self.voronoi = [[[] for y in range(self.size_y)] for x in range(self.size_x)]
        Q = Queue()
        for bId, buster in Blackboard.busters.items():
            if buster.isCarryingAGhost() or buster.stunned or (buster.isBustingAGhost() and buster.ghostBusted.hp == 0):
                continue
            square = self.getSquareFromPos(buster.pos)
            dist[square[0]][square[1]] = 0
            self.voronoi[square[0]][square[1]].append(bId)
            if len(self.voronoi[square[0]][square[1]]) == 1:
                Q.put(square)

        #RESETING BEST SQUARES
        tmpQ = Queue() 
        self.bestSquares = {}
        while not Q.empty():
            square = Q.get()
            group = tuple(self.voronoi[square[0]][square[1]])
            debug("A group", group)
            self.bestSquares[group] = (TURN, 0, [])
            tmpQ.put(square)
        Q = tmpQ
        
        #BFS
        while not Q.empty():
            square = Q.get()
            #debug("I'm in", square)
            for busterId in self.voronoi[square[0]][square[1]]:
                if self.isSquareEntirelyVisibleBy(square, busterId):
                    self.grid[square[0]][square[1]] = TURN
                    break

            #UPDATING BEST SQUARES
            group = tuple(self.voronoi[square[0]][square[1]])
            lastVisited, shortestDist, squares = self.bestSquares[group]
            currentLastVisited = self.grid[square[0]][square[1]]
            currentDist = dist[square[0]][square[1]]

            if currentLastVisited < lastVisited:
                lastVisited = currentLastVisited
                shortestDist = currentDist
                squares = []
            if lastVisited == currentLastVisited:
                if currentDist < shortestDist:
                    shortestDist = currentDist
                    squares = []
                if currentDist == shortestDist:
                    squares.append(square)
            self.bestSquares[group] = (lastVisited, shortestDist, squares)

            #CONTINUING BFS
            neighbours = self.getNeighbourSquares(square)
            for neighbour in neighbours:
                if dist[neighbour[0]][neighbour[1]] == INF:
                    dist[neighbour[0]][neighbour[1]] = dist[square[0]][square[1]] + 1
                    self.voronoi[neighbour[0]][neighbour[1]] = self.voronoi[square[0]][square[1]]
                    Q.put(neighbour)



    def getSquareFromPos(self, pos):
        return (min(pos[0] // GRID_SIZE, self.size_x - 1), min(pos[1] // GRID_SIZE, self.size_y - 1))

    def getNeighbourSquares(self, pos):
        x,y = pos
        ans = []
        for i in range(-1,2,1):
            for j in range(-1,2,1):
                if i != 0 or j != 0:
                    if 0 <= x+i < self.size_x and 0 <= y+j < self.size_y:
                        ans.append((x+i,y+j))
        return ans

    def isSquareEntirelyVisibleBy(self, square, busterId):
        buster = Blackboard.busters[busterId]
        leftTop = (square[0] * GRID_SIZE, square[1] * GRID_SIZE)
        rightTop = (leftTop[0], leftTop[1] + GRID_SIZE - 1)
        leftBottom = (leftTop[0] + GRID_SIZE - 1, leftTop[1])
        rightBottom = (leftBottom[0], rightTop[1])

        ans = True
        ans &= buster.isPosInSight(leftTop)
        ans &= buster.isPosInSight(rightTop)
        ans &= buster.isPosInSight(leftBottom)
        ans &= buster.isPosInSight(rightBottom)
        return ans

    def getMiddleOfSquare(self, square):
        coordX = square[0] * GRID_SIZE + GRID_SIZE // 2 - 1
        coordY = square[1] * GRID_SIZE + GRID_SIZE // 2 - 1
        return (coordX, coordY)


class Blackboard:

    ghosts = {}
    busters = {}
    enemies = {}
    currentBuster = None
    selectedGhost = None
    selectedEnemy = None
    newStunnedBusters = []

    def update():
        currentBuster = None
        selectedGhost = None
        selectedEnemy = None

        for ghostId, ghost in list(Blackboard.ghosts.items()):
            if ghost.lastSeen == TURN:
                continue    
            for busterId, buster in Blackboard.busters.items():
                if distance(ghost.pos, buster.pos) <= ACTION_RANGE:
                    Blackboard.ghosts.pop(ghostId)
                    break

        Blackboard.guessWhoStunnedWhom()

    def guessWhoStunnedWhom():
        for buster in Blackboard.newStunnedBusters:
            for enemyId, enemy in Blackboard.enemies.items():
                if enemy.couldHaveUsedStun and buster.isPosInRange(enemy.pos):
                    enemy.lastStun = TURN - 1
                    break
        Blackboard.newStunnedBusters = []

    def selectEnemy(enemy):
        Blackboard.selectedEnemy = enemy

########################################################################
class BehaviouralTreeNode:
    def __init__(self, *sons):
        self.sons = sons

    def run(self):
        return False

class Selector(BehaviouralTreeNode):
    def __init__(self, *sons):
        super().__init__(*sons)

    def run(self):
        for son in self.sons:
            if son.run():
                return True
        return False

class Sequence(BehaviouralTreeNode):
    def __init__(self, *sons):
        super().__init__(*sons)

    def run(self):
        for son in self.sons:
            if not son.run(): 
                return False
        return True

class Func(BehaviouralTreeNode):
    def __init__(self, booleanF):
        self.booleanF = booleanF

    def run(self):
        return self.booleanF()

class Iter(BehaviouralTreeNode):
    def __init__(self, iterableF, useElemF, son):
        self.iterableF = iterableF
        self.useElemF = useElemF
        self.son = son

    def run(self):
        for elem in self.iterableF():
            self.useElemF(elem)
            if self.son.run():
                return True
        return False


strategy = Selector(
        # If I'm stunned then I can't do anything
        Sequence(
            Func(lambda: Blackboard.currentBuster.stunned),
            Func(lambda: Blackboard.currentBuster.noOperation())),
        # If I'm carrying a ghost
        Sequence(
            Func(lambda: Blackboard.currentBuster.isCarryingAGhost()),
            Selector(
                Sequence(
                    Func(lambda: Blackboard.currentBuster.isInBase()),
                    Func(lambda: Blackboard.currentBuster.release())),
                Sequence(
                    Func(lambda: Blackboard.currentBuster.canUseStun()),
                    Iter(lambda: list(Blackboard.enemies.values()), 
                        lambda e: Blackboard.selectEnemy(e),
                        Sequence(
                            Func(lambda: Blackboard.currentBuster.isPosInRange(Blackboard.selectedEnemy.pos)),
                            Func(lambda: not Blackboard.selectedEnemy.stunned),
                            Func(lambda: Blackboard.selectedEnemy.canUseStun()),
                            Func(lambda: Blackboard.currentBuster.stunTheEnemy())))),
                Func(lambda: Blackboard.currentBuster.goToBase()))),
        # I'm not carrying a ghost but maybe I can steal someone's ghost
        Sequence(
            Func(lambda: Blackboard.currentBuster.canUseStun()),
            Iter(lambda: list(Blackboard.enemies.values()), 
                lambda e: Blackboard.selectEnemy(e),
                Sequence(
                    Func(lambda: Blackboard.selectedEnemy.isCarryingAGhost()),
                    Func(lambda: Blackboard.currentBuster.isPosInRange(Blackboard.selectedEnemy.pos)),
                    Func(lambda: not Blackboard.selectedEnemy.stunned),
                    Func(lambda: Blackboard.currentBuster.stunTheEnemy())))),
        # I can't steal anyone's ghost right now, but maybe I will be able to in the future.
        # If yes, chase the enemy
        Iter(lambda: list(Blackboard.enemies.values()), 
            lambda e: Blackboard.selectEnemy(e),
            Sequence(
                Func(lambda: Blackboard.selectedEnemy.isCarryingAGhost()),
                Func(lambda: Blackboard.currentBuster.canCatch(Blackboard.selectedEnemy)),
                Func(lambda: Blackboard.currentBuster.goToEnemyBase()))),
        # Maybe I will be able to steal a ghost from an enemy 
        Iter(lambda: list(Blackboard.enemies.values()), 
            lambda e: Blackboard.selectEnemy(e),
            Sequence(
                Func(lambda: Blackboard.selectedEnemy.isBustingAGhost()),
                Selector(
                    Sequence(
                        Func(lambda: Blackboard.currentBuster.isPosInRange(Blackboard.selectedEnemy.pos)),
                        Func(lambda: Blackboard.currentBuster.canUseStun()),
                        Func(lambda: not Blackboard.selectedEnemy.stunned),
                        Func(lambda: Blackboard.currentBuster.stunTheEnemy())),
                    Sequence(
                        Func(lambda: Blackboard.currentBuster.canStopTheEnemyBeforeBust()),
                        Func(lambda: Blackboard.currentBuster.goToEnemy(Blackboard.selectedEnemy))),
                    Sequence(
                        Func(lambda: Blackboard.currentBuster.canCatchAfterBust(Blackboard.selectedEnemy)),
                        Func(lambda: Blackboard.currentBuster.smartGoToStopTheEnemy()))))),
        # If I'm busting a ghost at the moment and some enemy comes into stun range 
        # and is not stunned yet - stun him
        Sequence(
            Func(lambda: Blackboard.currentBuster.isBustingAGhost()),
            Func(lambda: Blackboard.currentBuster.canUseStun()),
            Iter(lambda: list(Blackboard.enemies.values()), 
                lambda e: Blackboard.selectEnemy(e),
                Sequence(
                    Func(lambda: Blackboard.currentBuster.isPosInRange(Blackboard.selectedEnemy.pos)),
                    Func(lambda: not Blackboard.selectedEnemy.stunned),
                    Func(lambda: Blackboard.currentBuster.stunTheEnemy())))),
        # Can't steal anything, Bust the "best" ghost in my area
        Sequence(
            Func(lambda: Blackboard.currentBuster.selectOptimalGhost()),
            Selector(
                Sequence(
                    Func(lambda: Blackboard.currentBuster.canBust(Blackboard.selectedGhost)),
                    Func(lambda: Blackboard.currentBuster.bust(Blackboard.selectedGhost))),
                Func(lambda: Blackboard.currentBuster.goToGhost(Blackboard.selectedGhost)))),
        # If I have nothing to do, I guess I'll go explore the map
        Func(lambda: Blackboard.currentBuster.explore()))

########################################################################

def initialize():

    global SIZE_X
    global SIZE_Y
    global GRID_SIZE
    global TURN
    global STUN_COOLDOWN
    global BASE_RADIUS
    global MOVE_DIST
    global GHOST_MOVE_DIST
    global GHOST_HP
    global VISION_RANGE
    global ACTION_RANGE
    global BUST_MIN_DIST
    global BUSTER_COUNT
    global GHOST_COUNT
    global TEAM_ID
    global BASE
    global ENEMY_BASE
    global ENEMY_TEAM_ID
    global GHOST_ID
    global INF
    global DEBUG

    global grid

    SIZE_X = 16001
    SIZE_Y = 9001
    GRID_SIZE = 300
    TURN = 0
    STUN_COOLDOWN = 20
    BASE_RADIUS = 1600
    MOVE_DIST = 800
    GHOST_MOVE_DIST = 400
    GHOST_HP = 10
    VISION_RANGE = 2200
    ACTION_RANGE = 1760
    BUST_MIN_DIST = 900
    BUSTER_COUNT = int(input())  # the amount of busters you control
    GHOST_COUNT = int(input())  # the amount of ghosts on the map
    TEAM_ID = int(input())  # if this is 0, your base is on the top left of the map, if it is one, on the bottom right
    ENEMY_TEAM_ID = 1 - TEAM_ID
    GHOST_ID = -1
    INF = float("inf") 
    DEBUG = True

    if TEAM_ID == 0 :
        BASE = (0,0)
        ENEMY_BASE = (SIZE_X - 1, SIZE_Y - 1)
    else:
        BASE = (SIZE_X - 1, SIZE_Y - 1)
        ENEMY_BASE = (0,0)

    grid = Grid()

def updateEntity(entity_id, pos, entity_type, state, value):
    if entity_type == TEAM_ID:
        if not entity_id in Blackboard.busters:
            Blackboard.busters[entity_id] = Buster(entity_id)
        buster = Blackboard.busters[entity_id]
        buster.pos = pos
        if state == 1:
            buster.ghostBusted = None;
            if buster.ghost is None:
                buster.ghost = Blackboard.ghosts[value]
                Blackboard.ghosts.pop(value)
        elif state == 3:
            buster.ghost = None
            buster.ghostBusted = Blackboard.ghosts[value]
        else:
            buster.ghost = None
            buster.ghostBusted = None
            if state == 2 and buster.stunned == False:
                Blackboard.newStunnedBusters.append(buster)
            buster.stunned = state == 2

    elif entity_type == ENEMY_TEAM_ID:
        if not entity_id in Blackboard.enemies:
            Blackboard.enemies[entity_id] = Buster(entity_id)
        enemy = Blackboard.enemies[entity_id]
        enemy.pos = pos
        enemy.lastSeen = TURN
        if state == 1:
            enemy.ghostBusted = None
            if enemy.ghost is None or enemy.ghost.id != value:
                if value in Blackboard.ghosts:
                    enemy.ghost = Blackboard.ghosts[value]
                    Blackboard.ghosts.pop(value)
                else:
                    enemy.ghost = Ghost(value)
        elif state == 3:
            enemy.ghost = None
            if value in Blackboard.ghosts:
                enemy.ghostBusted = Blackboard.ghosts[value]
            else:
                enemy.ghostBusted = Ghost(value)
        else:
            enemy.ghost = None
            enemy.ghostBusted = None
            enemy.stunned = state == 2

    else: #It's a ghost
        if not entity_id in Blackboard.ghosts:
            Blackboard.ghosts[entity_id] = Ghost(entity_id)
        ghost = Blackboard.ghosts[entity_id]
        ghost.pos = pos
        ghost.hp = state
        ghost.bustersAttempting = value
        ghost.lastSeen = TURN

def distance(x, y):
    return math.sqrt((x[0]-y[0])**2 + (x[1]-y[1])**2)

def scalarProd(x, y):
        return x[0]*y[0] + x[1]*y[1]

def pairToNpVec(pair):
    debug("Pair to vector:", pair)
    vec = np.array([pair[0], pair[1]], dtype=np.float64)
    return vec

def debug(*args):
    if DEBUG:
        print(*args, file=sys.stderr)

# PROGRAM STARTS HERE

initialize()

# game loop
while True:

    TURN += 1
    debug("TURN:",TURN)
    entities = int(input())  # the number of busters and ghosts visible to you
    for i in range(entities):
        entity_id, x, y, entity_type, state, value = [int(j) for j in input().split()]
        updateEntity(entity_id, (x,y), entity_type, state, value)

    Blackboard.update()
    grid.update()
    #debug("########################")
    #for i in range(grid.size_x):
    #    debug(grid.grid[i])
    #debug("########################")
    orders = []

    for busterId, buster in Blackboard.busters.items():
        Blackboard.currentBuster = buster
        buster.commandToExecute = None
        strategy.run()
        debug("Strategy for buster",busterId,"computed")
        orders.append((busterId, buster.commandToExecute))

    # To debug: print("Debug messages...", file=sys.stderr)
    orders.sort()
    for order in orders:
        print(order[1])

# PROGRAM ENDS HERE
