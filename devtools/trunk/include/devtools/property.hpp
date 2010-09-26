template <typename T>
class Property
{
public:
	typedef T value_type;	
	Property() {}
	Property(value_type const & value) : value_(value) {}
		
protected:
	value_type value_;
};

#define property_(TYPE, NAME, IMPL) \
class NAME ## _ : public Property<TYPE> \
	{ \
	public: \
		NAME ## _ () {} \
		explicit NAME ## _ (value_type const & value) \
			: Property<TYPE>(value) {} \
		IMPL \
	} NAME

#define get_ \
	operator value_type const & () const \
	{ \
		return get(); \
	} \
	value_type const & get() const

#define set_ \
	Property<value_type> & operator = (value_type const & value) \
	{ \
		set(value); \
		return *this; \
	} \
	void set(value_type const & value)
