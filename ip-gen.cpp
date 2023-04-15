#include<bits/stdc++.h>
using namespace std;

#define int long long
#define vi vector<int>
#define vii vector<vector<int>> 
#define pb push_back 

void fast_io() {
    ios_base::sync_with_stdio(0);cin.tie(nullptr);cout.tie(nullptr);
}

void read(vi& a) {
    int n = a.size(); 
    for(int i = 0; i < n; i++) {
        cin >> a[i];
    }
}

void read2d(vii& a) {
    int n = a.size();
    int m = a[0].size();
    for(int i = 0; i < n; i++) {
        for(int j = 0; j < m; j++)
            cin >> a[i][j];
    }
}

void solve() {
    //int n; cin >> n;
    vector<string> s(36, "172.16.96.");
    for(int i = 33; i < 69; i++) {
        s[i - 33] += to_string(i);
    }
    for(auto &ele : s) {
        cout << ele << '\n';
    }
}

int32_t main() {
    fast_io();
    int t; cin >> t;
    while(t--) {
        solve();
    }
    return 0;
}
