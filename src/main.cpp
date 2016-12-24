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

void testPyhonModule()
{
	PyRun_SimpleString("import sys");
	PyRun_SimpleString("sys.path.append('.')");
	PyCppObject moduleName = PyUnicode_FromString("module1");
	PyCppObject module = PyImport_Import(moduleName);
	if (!module)
	{
		std::cout << "Error opening module1.py" << std::endl;
		return;
	}

	PyCppObject foo = PyObject_GetAttrString(module, "foo");
	if (!(foo && PyCallable_Check(foo)))
	{
		std::cout << "Error loading foo()" << std::endl;
		return;
	}

	PyCppObject value = PyObject_CallObject(foo, NULL);

	std::cout << "value obtained from python " <<  PyLong_AsLong(value) << std::endl;


}

using namespace std;

int main(int argc, char* argv[])
{
	testEmbeddedPython();
	testPyCPPInstance();
	
	PyCppInstance pyInstance;
	testPythonScript();
	testPyhonModule();
    return 0;
}
