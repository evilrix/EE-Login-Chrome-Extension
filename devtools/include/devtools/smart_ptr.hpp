// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Basic smart pointer for scalar and array types
// Note: this class is not thread safe
// evilrix 2009

namespace devtools {

   // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
   // This functor will delete a pointer to a scalar object
   template <typename ptrT>
   struct delete_scalar_policy
   {
      void operator()(ptrT * & px) { delete px; px = 0; }
   };

   // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
   // This functor will delete a pointer to an array of object
   template <typename ptrT>
   struct delete_array_policy
   {
      void operator()(ptrT * & px) { delete [] px; px = 0; }
   };

   // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
   // This is the smart pointer template, which takes pointer type and
   // a destruct policy, which it uses to destruct object(s) pointed to
   // when the reference counter for the object becomes zero.
   template <
      typename ptrT,
      template <
      typename ptrT
      > class destruct_policy
   >
   class smart_ptr
   {
   private:
      typedef delete_scalar_policy<ptrT> delete_policy_;
      typedef void (smart_ptr::*safe_bool_t)();
      typedef int refcnt_t;

   public:
      //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      // Make a nice typedef for the pointer type
      typedef ptrT ptr_type;

      //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      // dc_tor, c_tor and cc_tor
      smart_ptr() : px_(0), pn_(0) {}

      explicit smart_ptr(ptr_type * px) :
      px_(px), pn_(0) { pn_ = new int(1); }

      smart_ptr(smart_ptr const & o) : 
      px_(o.px_), pn_(o.pn_) { ++*pn_;}

      //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=	
      // d_tor, deletes the pointer using the destruct policy when the
      // reference counter for the object reaches zero
      ~smart_ptr()
      {
         try
         {
            if(pn_ && 0 == --*pn_)
            {
               delete_policy_()(px_);
               delete pn_;
            }
         }
         catch(...) 
         {
            // Ignored. Prevent percolation during stack unwinding.
         }
      }

      //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      // Assignment operator copies an existing pointer smart_ptr, but
      // in doing so will 'reset' the current pointer
      smart_ptr & operator = (smart_ptr const & o)
      {
         if(&o != this && px_ != o.px_)
         {
            reset(o.px_);
            pn_ = o.pn_;
            ++*pn_;
         }

         return *this;
      }

      //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=	
      // Performs a safe swap of two smart pointer.
      void swap(smart_ptr & o)
      {
         refcnt_t * pn = pn_;
         ptr_type * px = px_;

         pn_ = o.pn_;
         px_ = o.px_;

         o.pn_ = pn;
         o.px_ = px;
      }

      //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=	
      // Resets the current smart pointer. If a new pointer is provided
      // The reference counter will be set to one and the pointer will
      // be stored, if no pointer is provided the reference counter and
      // pointer wil be set to 0, setting this as a null pointer.
      void reset(ptr_type * px = 0)
      {
         smart_ptr o(px);
         swap(o);
      }

      //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      // Returns a reference to the object pointed too
      ptr_type & operator * () const { return *px_; }

      //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      // Invokes the -> operator on the pointer pointed too
      // NB. When you call the -> operator, the compiler  automatically
      //     calls the -> on the entity returned. This is a special,
      //     case, done to preserve normal indirection semantics.
      ptr_type * operator -> () const { return px_; }

      //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=	
      // Get the pointer being managed
      ptr_type * get() const { return px_; }

      //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      // Conversion to bool operator to facilitate logical pointer tests.
      // Returns a value that will logically be true if get != 0 else
      // and value that is logically false. We don't return a real
      // bool to prevent un-wanted automatic implicit conversion for
      // instances where it would make no semantic sense, rather we
      // return a pointer to a member function as this will always
      // implicitly convert to true or false when used in a boolean
      // context but will not convert, for example, to an int type.
      operator safe_bool_t () const { return px_ ? &smart_ptr::true_ : 0; }

   private:
      //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      // A dummy member function used to represent a logically true
      // boolean value, used by the conversion to bool operator.
      void true_(){};

   private:
      //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      // Poiners to the object being managed and the reference counter
      ptr_type * px_;
      refcnt_t * pn_;

      //=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
   };

   // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
   // Facility class to simplify the creation of a smart pointer that
   // implements a 'delete scalar policy'.
   template <typename ptrT>
   struct scalar_smart_ptr
   { 
      typedef smart_ptr<ptrT, delete_scalar_policy> type;
      private: scalar_smart_ptr();
   };

   // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
   // Facility class to simplify the creation of a smart pointer that
   // implements a 'delete array policy'.
   template <typename ptrT>
   struct array_smart_ptr
   { 
      typedef smart_ptr<ptrT, delete_array_policy> type;
      private: array_smart_ptr();
   };

   // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

}

