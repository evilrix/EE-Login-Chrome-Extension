#define property_(TYPE, OWNR, NAME, IMPL) \
   private: \
      class NAME ## __ \
      { \
      friend class OWNR; \
      public: \
         typedef NAME ## __ this_type; \
         typedef TYPE value_type; \
         NAME ## __ () {} \
         explicit NAME ## __ (value_type const & value) \
            : NAME ## (value) {} \
         IMPL \
      private: \
         value_type NAME ##; \
      }; \
   public: \
      NAME ## __ NAME;

#define get_ \
   operator value_type const & () const \
   { \
      return get(); \
   } \
   value_type const & get() const

#define set_ \
   this_type & operator = (value_type const & value) \
   { \
      set(value); \
      return *this; \
   } \
   void set(value_type const & value)

#define xprop_(NAME) \
   NAME ## . ## NAME
