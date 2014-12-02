#include <iostream>

#include <TH1.h>

#include "hist_css.h"

using namespace std;

#define test(var) \
  cout <<"\033[36m"<< #var <<"\033[0m"<< " = " << var << endl;

int main(int argc, char **argv)
{
  csshists _h("test/hists.css");

  TH1* h = _h.mkhist("hist");
  test(h->GetName())
  test(h->GetNbinsX())
  test(h->GetBinLowEdge(1))
  test(h->GetLineColor())
  test(h->GetLineWidth())

  return 0;
}
