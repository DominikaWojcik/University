import sys
import math
import queue

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

    def moveTo(self, point):
        print("MOVE", point[0], point[1])

    def bust(self, ghost):
        print("BUST", ghost.id)

    def stun(self, buster):
        print("STUN", buster.id)

    def release(self):
        print("RELEASE")

    def useRadar(self):
        self.usedRadar = True
        print("RADAR")

    def canUseStun(self):
        return TURN - self.lastStun >= STUN_COOLDOWN or self.lastStun == 0

    def carriesGhost(self):
        return not self.ghost is None

    def isPosInSight(self, pos):
        return distance(self.pos, pos) <= VISION_RANGE

class Ghost:

    def __init__ (self, id):
        self.id = id
        self.pos = (0,0)
        self.hp = GHOST_HP
        self.lastSeen = 0
        self.bustersAttempting = 0 

class Grid:

    def __init__ (self):
        self.size_x = SIZE_X / GRID_SIZE
        self.size_y = SIZE_Y / GRID_SIZE
        self.grid = [[0 for x in range(self.size_x)] for y in range(self.size_y)]
        self.voronoi = [[[] for x in range(self.size_x)] for y in range(self.size_y)]

    def update(self):
        dist = [[INF for x in range(self.size_x)] for y in range(self.size_y)]
        self.voronoi = [[[] for x in range(self.size_x)] for y in range(self.size_y)]
        Q = Queue()
        for bId, buster in Blackboard.busters:
            square = self.getSquareFromPos(buster.pos)
            dist[square[0]][square[1]] = 0
            voronoi[square[0]][square[1]].append(bId)
            Q.put(square)

        while not Q.empty():
            square = Q.get()
            neighbours = self.getNeighbourSquares(square)
            for neighbour in neighbours:
                if dist[neighbour[0]][neighbour[1]] == INF:
                    dist[neighbour[0]][neighbour[1]] = dist[square[0]][square[1]] + 1
                    voronoi[neighbour[0]][neighbour[1]] = voronoi[square[0]][square[1]]
                    Q.put(neighbour)

    def getSquareFromPos(self, pos):
        return (pos[0] % self.size_x, pos[1] % self.size_y)

    def getNeighbourSquares(self, pos):
        x,y = pos
        ans = []
        for i in range(-1,1,1):
            for j in range(-1,1,1):
                if i != 0 or j != 0:
                    if 0 <= x+i < self.size_x and 0 <= y+j < self.size_y:
                        ans.append((x+i,y+j))
        return ans


class Blackboard:

    ghosts = {}
    busters = {}
    enemies = {}

    def update():
        for ghostId, ghost in ghosts.items():
            if ghost.lastSeen == TURN:
                continue    
            for busterId, buster in busters.items():
                if distance(ghost.pos, buster.pos) <= ACTION_RANGE:
                    ghosts.pop(ghostId)
                    break



    
# PROGRAM STARTS HERE

initialize()

# game loop
while True:

    TURN += 1
    entities = int(input())  # the number of busters and ghosts visible to you
    for i in range(entities):
        entity_id, x, y, entity_type, state, value = [int(j) for j in input().split()]
        updateEntity(entity_id, (x,y), entity_type, state, value)
            
    Blackboard.update()
    grid.update()

    for i in range(BUSTER_COUNT):
        # Write an action using print
        # To debug: print("Debug messages...", file=sys.stderr)

        # MOVE x y | BUST id | RELEASE
        print("MOVE 8000 4500")

# PROGRAM ENDS HERE

def initialize():

    SIZE_X = 16001
    SIZE_Y = 9001
    GRID_SIZE = 100
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
    INF = sys.maxint

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

