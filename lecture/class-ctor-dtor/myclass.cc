// myclass.cc

#include <iostream>
#include "myclass.h"

// C++ using declarations for objects 'cout' and 'endl'
using std::cout;
using std::endl;

namespace ece3220 {

// Default constructor (a.k.a., default ctor)
MyClass::MyClass()
    : value_{ 0 }
{
    cout << "MyClass::MyClass(): value_ = " << value_ << endl ;
}

// converting constructor (a.k.a., converting ctor)
MyClass::MyClass( int value )
    : value_{ value }
{
    cout << "MyClass::MyClass(int): value_ = " << value_ << endl ;
}

// destructor (a.k.a., "dtor")
MyClass::~MyClass()
{
    cout << "MyClass::~MyClass(): value = " << value_ << endl ;
}

} // namespace ece3220
