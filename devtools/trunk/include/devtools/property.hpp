template <typename T>
class Property
{
public:
	typedef T value_type;
	
	Property(value_type vt = value_type()) : vt_(vt) {}
	
	// Unfortunately, due to the rules of C++ this must be overridden
	// in the specialised class and then called explicitly.
	Property<int> & operator = (value_type const & vt)
	{
		put(vt);
		return *this;
	}
	
	operator value_type const & () const
	{
		return get();
	}
	
protected:
	// Override these to add specialised validation
	virtual value_type const & get() const { return vt_; };
	virtual void put(value_type const & vt){ vt_ = vt; };

	value_type vt_;
};

#include <stdexcept>

class MyClass
{
public:

	// A property definition
	class Value_ : public Property<int>
	{
	public:
		// Pass assignment on to the base class to handle
		Property<int> & operator = (value_type const & vt)	{
			return Property<int>::operator=(vt);
		}
		
	private:
		// Implement get() if you want to specialise the behavior
		
		void put(value_type const & vt) // Only allow 0 to 99
		{
			if(vt < 0 || vt > 99) {
				throw std::runtime_error("validation error");
			}
			
			Property<int>::put(vt);
		}
		
	} Value; 
};	

#include <iostream>

int main()
{
	MyClass myClass;
	myClass.Value = 99;
	
	int foo = myClass.Value;
	
	std::cout << foo << std::endl;

	try
	{
		myClass.Value = 100; // Fails validation
	}
	catch(std::exception const & e)
	{
		std::cerr << e.what() << std::endl;
	}
}
