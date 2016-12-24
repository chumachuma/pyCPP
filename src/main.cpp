#include <Python.h>
#include <iostream>
//https://www.codeproject.com/Articles/820116/Embedding-Python-program-in-a-C-Cplusplus-code

void checkPython ()
{
	Py_Initialize();
	PyRun_SimpleString("print('Python is running correctly')");
	Py_Finalize();
}

using namespace std;

int main(int argc, char* argv[])
{
	checkPython();
    return 0;
}
