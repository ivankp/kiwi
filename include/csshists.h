#ifndef flock_csshists_h
#define flock_csshists_h

#include <string>

class TH1;

namespace flock {

class csshists {
  class impl;
  impl *_impl;

public:
  csshists(const std::string& cssfilename);
  ~csshists();

  TH1* mkhist(const std::string& name) const;
};

}

#endif
