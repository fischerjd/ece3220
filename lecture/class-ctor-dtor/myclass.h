// myclass.h

#ifndef ECE3220_MYCLASS_H
#define ECE3220_MYCLASS_H

namespace ece3220 {

class MyClass {
public:
    // default constructor
    MyClass();

    // converting constructor
    MyClass(int value);

    // destructor
    ~MyClass();
    
private:
    int value_;
};

}

#endif // ECE3220_MYCLASS_H
