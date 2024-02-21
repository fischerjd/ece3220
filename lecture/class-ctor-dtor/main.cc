// main.cc

#include <iostream>
#include "myclass.h"

//=========================================================================
//  Function Prototype(s)
//=========================================================================

void PrintExampleBanner( int example_number );


//=========================================================================
//  main()
//=========================================================================
int main()
{
    using ece3220::MyClass;

    {   // example 1
        PrintExampleBanner( 1 );
        MyClass mc ;    // default ctor
    } // <- mc's lifetime ends dtor called on mc

    {   // example 2
        PrintExampleBanner( 2 );
        MyClass mc{ 123 };  // converting ctor
    } // <- mc's lifetime ends dtor called on mc

    {   // example 3
        PrintExampleBanner( 3 );
        MyClass amc[3];
        // amc[0] - default ctor
        // amc[1] - default ctor
        // amc[2] - default ctor
    } // <- amc's lifetime ends; dtor called on each MyClass object in amc

    {   // example 4
        PrintExampleBanner( 4 );
        MyClass amc[3]{ 123, 456 };
        // amc[0] - converting ctor
        // amc[1] - converting ctor
        // amc[2] - default ctor
    } // <- amc's lifetime ends; dtor called on each MyClass object in amc

    {   // example 5
        PrintExampleBanner( 5 );
        MyClass* pmc = new MyClass ;    // default ctor
        delete pmc ;    // dynamic MyClass object's lifetime ends
        pmc = nullptr ;
    }

    {   // example 6
        PrintExampleBanner( 6 );
        MyClass* pmc = new MyClass{ 111 };    // converting ctor
        delete pmc ;    // dynamic MyClass object's lifetime ends
        pmc = nullptr ;
    }

    {   // example 7
        PrintExampleBanner( 7 );
        MyClass* pamc = new MyClass[3];
        // [0] - default ctor
        // [1] - default ctor
        // [2] - default ctor
        delete[] pamc ;    // lifetime ends for the dynamic array of MyClass objects
        pamc = nullptr ;
    }

    {   // example 8
        PrintExampleBanner( 8 );
        MyClass* pamc = new MyClass[3]{ 222, 333, 444 };
        // [0] - converting ctor
        // [1] - converting ctor
        // [2] - converting ctor
        delete[] pamc ;    // lifetime ends for the dynamic array of MyClass objects
        pamc = nullptr ;
    }


    return 0;
}

//=========================================================================
//  PrintExampleBanner()
//=========================================================================

void PrintExampleBanner( int example_number )
{
    std::cout 
        << "=======================================================\n"
        << ":: Example " << example_number << " ::\n" 
        << "-------------------------------------------------------"
        << std::endl ;
}

