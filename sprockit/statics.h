#ifndef sprockit_common_STATICS_H
#define sprockit_common_STATICS_H

#include <list>

namespace sprockit {

class statics {
 public:
  typedef void (*clear_fxn)(void);

  static void
  register_finish(clear_fxn fxn);

  static void
  finish();

 protected:
  static std::list<clear_fxn>* fxns_;

};

template <class T>
class need_delete_statics {
 public:
  need_delete_statics(){
    statics::register_finish(&T::delete_statics);
  }
};

#define free_static_ptr(x) \
 if (x) delete x; x = 0

}

#endif // STATICS_H
