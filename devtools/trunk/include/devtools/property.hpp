#define property_(TYPE, NAME, IMPL) \
	class NAME ## __ \
	{ \
	public: \
      typedef NAME ## __ this_type; \
   	typedef TYPE value_type; \
		NAME ## __ () {} \
		explicit NAME ## __ (value_type const & value_) \
			: NAME ## _(value_) {} \
		IMPL \
   private: \
	   value_type NAME ## _; \
	} NAME

#define get_ \
	operator value_type const & () const \
	{ \
		return get(); \
	} \
	value_type const & get() const

#define set_ \
	this_type & operator = (value_type const & value_) \
	{ \
		set(value_); \
		return *this; \
	} \
	void set(value_type const & value_)
