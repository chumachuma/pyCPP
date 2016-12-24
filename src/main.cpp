#include <Python.h>
#include <iostream>
#include "pyCpp.h"
//https://www.codeproject.com/Articles/820116/Embedding-Python-program-in-a-C-Cplusplus-code

void testEmbeddedPython()
{
	Py_Initialize();
	PyRun_SimpleString("print('Python is running correctly')");
	Py_Finalize();
}

void testPyCPPInstance()
{
	PyCppInstance pyInstance;
	PyRun_SimpleString("print('PyCppInstance class helper is running correctly')");
}

void testPythonScript()
{
	FILE* file = _Py_fopen("script1.py", "r");
	//FILE* file = fopen("script1.py", "r");
	if (file==NULL)
	{
		std::cout <<  "Error opening script.py" << std::endl;
		return;
	}
	PyRun_SimpleFile(file, "script1");
}

using namespace std;

int main(int argc, char* argv[])
{
	testEmbeddedPython();
	testPyCPPInstance();
	
	PyCppInstance pyInstance;
	testPythonScript();

    return 0;
}
