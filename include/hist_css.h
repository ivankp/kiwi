#ifndef mithril_hist_css_h
#define mithril_hist_css_h

#include <string>

class TH1;

class csshists {
  class impl;
  impl *_impl;

public:
  csshists(const std::string& cssfilename);
  ~csshists();

  TH1* mkhist(const std::string& name) const;
};

#endif
