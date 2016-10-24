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
BUSTER_COUNT = None
BUST_MIN_DIST = None
GHOST_COUNT = None
TEAM_ID = None
ENEMY_TEAM_ID = None
GHOST_ID = None
INF = None

grid = None


class Buster:

    def __init__ (self, id):
        self.id = id
        self.pos = (0,0)
        self.stunned = False
        self.usedRadar = False
        self.lastStun = 0
        self.ghost = None
        self.commandToExecute = None

    def moveTo(self, point):
        self.commandToExecute = "MOVE %d %d" % (point[0], point[1])
        return True

    def bust(self, ghost):
        self.commandToExecute = "BUST %d" % ghost.id
        return True

    def stun(self, buster):
        self.commandToExecute = "STUN %d" % buster.id
        self.lastStun = TURN
        return True

    def release(self):
        self.commandToExecute = "RELEASE"
        return True

    def useRadar(self):
        self.usedRadar = True
        self.commandToExecute = "RADAR"
        return True

    def canUseStun(self):
        return TURN - self.lastStun >= STUN_COOLDOWN or self.lastStun == 0

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

        if len(ghostsInMyArea) == 0:
            return False

        ghostsInMyArea.sort(key=lambda gh: self.estimateRoundsToCapture(gh))
        Blackboard.selectedGhost = ghostsInMyArea[0]
        return True

    def estimateRoundsToCapture(self, ghost):
        dist = distance(self.pos, ghost.pos)

        #Getting to the ghost:
        roundsToReach = 0
        if dist < BUST_MIN_DIST:
            roundsToReach = 1
        elif dist > ACTION_RANGE:
            roundsToReach = math.ceil((dist - ACTION_RANGE // 2) / MOVE_DIST)

        #Busting the ghost:
        roundsToBust = 1

        #Returning to the base:
        ghostVec = pairToNpVec(ghost.pos)
        base = pairToNpVec(BASE)
        ghostToBase = base - ghostVec
        dist = np.linalg.norm(ghostToBase)
        dist = max(0, dist - ACTION_RANGE // 2)
        roundsToReturn = math.ceil(dist / MOVE_DIST)

        return roundsToReach + roundsToBust + roundsToReturn

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
            if buster.isCarryingAGhost():
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

    def update():
        for ghostId, ghost in list(Blackboard.ghosts.items()):
            if ghost.lastSeen == TURN:
                continue    
            for busterId, buster in Blackboard.busters.items():
                if distance(ghost.pos, buster.pos) <= ACTION_RANGE:
                    Blackboard.ghosts.pop(ghostId)
                    break

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

strategy = Selector(
        Sequence(
            Func(lambda: Blackboard.currentBuster.isCarryingAGhost()),
            Selector(
                Sequence(
                    Func(lambda: Blackboard.currentBuster.isInBase()),
                    Func(lambda: Blackboard.currentBuster.release())),
                Func(lambda: Blackboard.currentBuster.goToBase()))),
            Sequence(
                Func(lambda: Blackboard.currentBuster.selectOptimalGhost()),
                Selector(
                    Sequence(
                        Func(lambda: Blackboard.currentBuster.canBust(Blackboard.selectedGhost)),
                        Func(lambda: Blackboard.currentBuster.bust(Blackboard.selectedGhost))),
                    Func(lambda: Blackboard.currentBuster.goToGhost(Blackboard.selectedGhost)))),
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
    global ENEMY_TEAM_ID
    global GHOST_ID
    global INF

    global grid

    SIZE_X = 16001
    SIZE_Y = 9001
    GRID_SIZE = 300
    TURN = 0
    STUN_COOLDOWN = 10
    BASE_RADIUS = 1600
    MOVE_DIST = 800
    GHOST_MOVE_DIST = 400
    GHOST_HP = 0
    VISION_RANGE = 2200
    ACTION_RANGE = 1760
    BUST_MIN_DIST = 900
    BUSTER_COUNT = int(input())  # the amount of busters you control
    GHOST_COUNT = int(input())  # the amount of ghosts on the map
    TEAM_ID = int(input())  # if this is 0, your base is on the top left of the map, if it is one, on the bottom right
    ENEMY_TEAM_ID = 1 - TEAM_ID
    GHOST_ID = -1
    INF = float("inf") 

    if TEAM_ID == 0 :
        BASE = (0,0)
    else:
        BASE = (SIZE_X - 1, SIZE_Y - 1)

    grid = Grid()

def updateEntity(entity_id, pos, entity_type, state, value):
    if entity_type == TEAM_ID:
        if not entity_id in Blackboard.busters:
            Blackboard.busters[entity_id] = Buster(entity_id)
        buster = Blackboard.busters[entity_id]
        buster.pos = pos
        if state == 1:
            if buster.ghost is None:
                buster.ghost = Blackboard.ghosts[value]
                Blackboard.ghosts.pop(value)
        elif not buster.ghost is None:
            buster.ghost = None

    elif entity_type == ENEMY_TEAM_ID:
        if not entity_id in Blackboard.enemies:
            Blackboard.enemies[entity_id] = Buster(entity_id)
        enemy = Blackboard.enemies[entity_id]
        enemy.pos = pos
        if state == 1:
            if enemy.ghost is None:
                if value in Blackboard.ghosts:
                    enemy.ghost = Blackboard.ghosts[value]
                    Blackboard.ghosts.pop(value)
                else:
                    enemy.ghost = Ghost(value)
        elif not enemy.ghost is None:
            enemy.ghost = None

    else: #It's a ghost
        if not entity_id in Blackboard.ghosts:
            Blackboard.ghosts[entity_id] = Ghost(entity_id)
        ghost = Blackboard.ghosts[entity_id]
        ghost.pos = pos
        ghost.bustersAttempting = value
        ghost.lastSeen = TURN

def distance(x, y):
    return math.sqrt((x[0]-y[0])**2 + (x[1]-y[1])**2)

def pairToNpVec(pair):
    debug("Pair to vector:", pair)
    vec = np.array([pair[0], pair[1]], dtype=np.float64)
    return vec

def debug(*args):
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
        orders.append((busterId, buster.commandToExecute))

    # To debug: print("Debug messages...", file=sys.stderr)
    orders.sort()
    for order in orders:
        print(order[1])

# PROGRAM ENDS HERE
