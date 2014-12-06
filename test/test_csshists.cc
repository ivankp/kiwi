#include <iostream>
#include <vector>

#include <TH1.h>

#include "csshists.h"

using namespace std;
using namespace kiwi;

#define test(var) \
  cout <<"\033[36m"<< #var <<"\033[0m"<< " = " << var << endl;

int main(int argc, char **argv)
{
  csshists _h("test/hists.css");

  vector<TH1*> h_;
  h_.push_back( _h.mkhist("histo") );
  h_.push_back( _h.mkhist("h_red") );
  h_.push_back( _h.mkhist("thick_h") );
  h_.push_back( _h.mkhist("hist") );

  for (size_t i=0,n=h_.size();i<n;++i) {
    TH1* h = h_[i];
    test(h->ClassName())
    test(h->GetName())
    test(h->GetNbinsX())
    test(h->GetBinLowEdge(1))
    test(h->GetLineColor())
    test(h->GetLineWidth())
    cout << endl;
  }

  return 0;
}
