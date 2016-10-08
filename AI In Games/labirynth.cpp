#include <queue>
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
vector<pair<int,int> > exitPath;

const char CONTROL_ROOM = 'C';
const char START = 'T';
const char UNEXPLORED = '?';
const char OBSTACLE = '#';
const int UNDEFINED = -1e6-7;
const pair<int,int> UNKNOWN = pair<int,int>(-1,-1);

int R; // number of rows.
int C; // number of columns.
int A; // number of rounds between the time the alarm countdown is activated and the time the alarm goes off.

vector<string> map;
vector<vector<int> > dist; 
int KR; // row where Kirk is located.
int KC; // column where Kirk is located.

bool alarmOn = false;

template <typename T>
void emptyAQueue(queue<T>& q){
    while(!q.empty()) q.pop();
}

vector<pair<int,int> > getNeighbours(pair<int,int> p){
    vector<pair<int,int> > toRet;

    if(p.first - 1 >= 0)
        toRet.push_back(make_pair(p.first - 1, p.second));
    if(p.first + 1 < R)
        toRet.push_back(make_pair(p.first + 1, p.second));
    if(p.second - 1 >= 0)
        toRet.push_back(make_pair(p.first, p.second - 1));
    if(p.second + 1 < C)
        toRet.push_back(make_pair(p.first, p.second + 1));

    return toRet;
}

pair<int,int> getNextField(pair<int,int> p, bool storeExitPath){
    cerr<<"Jestem getNextField w ("<<p.first<<","<<p.second<<") z dist "<<dist[p.first][p.second]<<endl;
    if(storeExitPath) exitPath.push_back(p);

    if(dist[p.first][p.second] == 1) return p;
    vector<pair<int,int> > neighbours = getNeighbours(p);

    for(int i=0;i<neighbours.size();i++)
        if(dist[neighbours[i].first][neighbours[i].second] == dist[p.first][p.second] - 1)
            return getNextField(neighbours[i], storeExitPath);
}

pair<int,int> discover(int row, int col, bool returnToStart){
    for(int i=0;i<R;i++)
        for(int j=0;j<C;j++)
            dist[i][j] = UNDEFINED;
    dist[row][col] = 0;

    queue<pair<int,int> > Q;
    Q.push(make_pair(row, col));

    pair<int,int> firstUnknown = UNKNOWN;
    pair<int,int> controlRoom = UNKNOWN;
    pair<int,int> start = UNKNOWN;

    while(!Q.empty()){
        pair<int,int> current = Q.front();
        Q.pop();
        cerr<<"Jestem w ("<<current.first<<","<<current.second<<")"<<endl;

        if(map[current.first][current.second] == UNEXPLORED){
            if(firstUnknown == UNKNOWN)
                firstUnknown = current;
        }
        else {
            if(!returnToStart){
                if(map[current.first][current.second] == CONTROL_ROOM){
                    controlRoom = current;
                    emptyAQueue(Q);
                    break;
                }
            }
            else {
                if(map[current.first][current.second] == START){
                    start = current;
                    emptyAQueue(Q);
                    break;
                }
            }

            vector<pair<int,int> > neighbours = getNeighbours(current);
            for(int i = 0; i < neighbours.size();i++){
                pair<int,int> n = neighbours[i];
                if(map[n.first][n.second] != OBSTACLE && dist[n.first][n.second] == UNDEFINED)
                {
                    dist[n.first][n.second] = dist[current.first][current.second] + 1;
                    Q.push(n);
                }
            }
        }
    }

    if(!returnToStart){
        if(controlRoom != UNKNOWN) return getNextField(controlRoom, false);
        return getNextField(firstUnknown, false);
    }
    else{
        return getNextField(start, true);
    }
}

pair<int,int> getNextFieldToExit(){
    pair<int,int> field = exitPath.back();
    exitPath.pop_back();
    return field;
}

void printDirection(pair<int,int> nextField){
    // Write an action using cout. DON'T FORGET THE "<< endl"
    // To debug: cerr << "Debug messages..." << endl;
    cerr << "KR: " << KR << " KC: " << KC << endl;
    cerr<<"Next field: ("<<nextField.first<<","<<nextField.second<<")"<< endl;

    if(KR == nextField.first){
        if(KC < nextField.second)
            cout<<"RIGHT";
        else
            cout<<"LEFT";
    }
    else {
        if(KR < nextField.first )
            cout<<"DOWN";
        else
            cout<<"UP";
    }
    cout<<endl;

}


int main()
{
    cin >> R >> C >> A; cin.ignore();
    
    map.resize(R);
    dist.resize(R);
    for(int i = 0; i < R; i++)
        dist[i].resize(C);

    alarmOn = false;

    // game loop
    while (1) {
        cin >> KR >> KC; cin.ignore();
        cerr<< KR << " " << KC << endl;
        for (int i = 0; i < R; i++) {
            string ROW; // C of the characters in '#.TC?' (i.e. one line of the ASCII maze).
            cin >> ROW; cin.ignore();
            cerr << ROW << endl;
            map[i] = ROW;
        }

        if(map[KR][KC] == CONTROL_ROOM){
            alarmOn = true;
            discover(KR, KC, true);
        }

        pair<int,int> nextField;
        //TODO: Czasami okazuje sie, ze brakuje mi informacji o planszy i nie wracam najlepszą sciezka jaka sie da
        if(alarmOn)
            nextField = getNextFieldToExit();
        else
            nextField = discover(KR, KC, false);

        cerr<<"Next field: ("<<nextField.first<<","<<nextField.second<<")"<< endl;
        printDirection(nextField);
    }
}