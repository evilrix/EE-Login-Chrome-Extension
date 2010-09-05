template <typename T>
class Property
{
public:
	typedef T value_type;
	
	Property(value_type value = value_type()) : value_(value) {}
	
	Property<int> & operator = (value_type const & value)
	{
		set(value);
		return *this;
	}
	
	operator value_type const & () const
	{
		return get();
	}
	
protected:
	value_type const & get() const { return value_; };
	void set(value_type const & value){ value_ = value; };

	value_type value_;
};

#define property_(TYPE, NAME, IMPL) \
class NAME ## _ : public Property<TYPE> \
	{ \
	public: \
		Property<int> & operator = (value_type const & value)	{ \
			return Property<int>::operator=(value); \
		} \
	private: \
		IMPL \
	} NAME

#define get_ \
	value_type const & get() const

#define set_ \
	void set(value_type const & value)
