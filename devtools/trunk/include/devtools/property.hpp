#define property_(TYPE, OWNR, NAME, IMPL) \
	private: \
		class NAME ## __ \
		{ \
		friend class OWNR; \
		public: \
		  typedef NAME ## __ this_type; \
   		typedef TYPE valuetype; \
			NAME ## __ () {} \
			explicit NAME ## __ (valuetype const & value) \
				: NAME ## (value) {} \
			IMPL \
	   private: \
		   valuetype NAME ##; \
		}; \
	public: \
		NAME ## __ NAME;

#define get_ \
	operator valuetype const & () const \
	{ \
		return get(); \
	} \
	valuetype const & get() const

#define set_ \
	this_type & operator = (valuetype const & value) \
	{ \
		set(value); \
		return *this; \
	} \
	void set(valuetype const & value)

#define xprop_(NAME) \
	NAME ## . ## NAME
