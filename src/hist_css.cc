#include "hist_css.h"

#include <iostream>
#include <fstream>
#include <vector>
#include <stdexcept>

#include <boost/regex.hpp>
#include <boost/algorithm/string.hpp>

#include <TH1.h>

using namespace std;

#define test(var) \
  cout <<"\033[36m"<< #var <<"\033[0m"<< " = " << var << endl;

// Functions ********************************************************


// Properties *******************************************************

struct prop {
  string str;
  prop(const string& str): str(str) { }
};

// PIMPL ************************************************************

struct csshists::impl {
  vector< pair< boost::regex*,vector<prop*> > > rules;

  /*~impl() {
    for (size_t i=0,n=rules.size();i<n;++i) {
      delete rules[i].first;
      delete rules[i].second;
    }
  }*/
};

// Constructor ******************************************************

csshists::csshists(const string& cssfilename)
: _impl( new impl )
{
  // Read CSS file
  ifstream css(cssfilename);
  char c;
  bool brak=false, q1=false, q2=false;
  vector< pair< string, vector<string> > > rule_str(1);
  while ( css.get(c) ) {
    if (brak) {
      if (!q2) if (c=='\'') q1 = !q1;
      if (!q1) if (c=='\"') q2 = !q2;

      if (!(q1||q2)) {
        if (c=='}') {
          brak=false;
          // remove whitespace from last property string
          boost::algorithm::trim(rule_str.back().second.back());
          // start new rule
          rule_str.push_back(pair< string, vector<string> >());
          continue;
        }
        if (c=='{') { throw runtime_error(
          "consecutive { in file \""+cssfilename+"\""
        ); }
      }

      if (c==';') {
        // remove whitespace from last property string
        boost::algorithm::trim(rule_str.back().second.back());
        // start new property string
        rule_str.back().second.push_back(string());
      } else {
        rule_str.back().second.back() += c;
      }

    } else {
      if (c=='{') {
        brak=true;
        // start first property string
        rule_str.back().second.push_back(string());
        continue;
      }
      if (c=='}') { throw runtime_error(
        "} before { in file \""+cssfilename+"\""
      ); }

      rule_str.back().first += c;
    }
  }

  // Convert rules to regex and props
  _impl->rules.reserve(rule_str.size());
  for (size_t i=0,n=rule_str.size();i<n;++i) {
    if (rule_str[i].second.size()==0) continue; // skip blank rule

    _impl->rules.push_back( make_pair(
      new boost::regex( rule_str[i].first ),
      vector<prop*>()
    ) );
    _impl->rules.back().second.reserve( rule_str[i].second.size() );
    for (size_t j=0,m=rule_str[i].second.size();j<m;++j) {
      const string& prop_str = rule_str[i].second[j];
      if (prop_str.size()==0) continue; // skip blank property

      _impl->rules.back().second.push_back(
        new prop( prop_str )
      );
    }
  }
  

  // Test print
  for (size_t i=0,n=_impl->rules.size();i<n;++i) {
    cout << _impl->rules[i].first->str() << endl;
    for (size_t j=0,m=_impl->rules[i].second.size();j<m;++j)
      cout <<j<<". " << _impl->rules[i].second[j]->str <<';'<< endl;
    cout << "-----------" << endl;
  }
}

// Make Historgram **************************************************

TH1* csshists::mkhist(const std::string& name) const {
  return NULL;
}

// Destructor *******************************************************

csshists::~csshists() { delete _impl; }
