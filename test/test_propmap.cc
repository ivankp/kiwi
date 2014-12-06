#include <iostream>

#include "propmap.h"

using namespace std;

class c1: public prop<char> {
public:
  c1(const string& s): prop<char>(s[0]) { }
};

class c2: public prop<char> {
public:
  c2(const string& s): prop<char>(s[1]) { }
};

int main (int agrc, char** argv)
{
  vector<string> s;
  s.push_back("rat");
  s.push_back("hat");
  s.push_back("rug");
  s.push_back("rig");
  s.push_back("tag");
  s.push_back("bag");
  s.push_back("hot");
  s.push_back("tug");

  propmap<string> pm(2);

  vector<prop_ptr> key(2);
  for (size_t i=0,n=s.size();i<n;++i) {
    key[0] = new c1(s[i]);
    key[1] = new c2(s[i]);
    pm.insert(key,s[i]);
  }

  pmloop(pm,i1,0) {
    pmloop(pm,i2,1) {
      key[0] = *i1;
      key[1] = *i2;
      //cout << key[0]->str() << "  " << key[1]->str() << endl;
      string str;
      if (pm.get(key,str)) cout << str << endl;
    }
  }

  cout << endl;

  pmloop(pm,i2,1) {
    pmloop(pm,i1,0) {
      key[0] = *i1;
      key[1] = *i2;
      string str;
      if (pm.get(key,str)) cout << str << endl;
    }
  }

  return 0;
}
