#pragma once
#ifndef PYTHON_CPP_H
#define PYTHON_CPP_H

#include <Python.h>

class PyCppInstance
{
	public:
		PyCppInstance(){Py_Initialize();};
		~PyCppInstance(){Py_Finalize();};
};

class PyCppObject
{
	private:
		PyObject *p;
	public:
		PyCppObject(): p(NULL){};
		PyCppObject(PyObject* pythonObject): p(pythonObject){};
		~PyCppObject(){Release();};

		PyObject* getObject(){return p;};
		PyObject* setObject(PyObject* pythonObject){return (p=pythonObject);};
		PyObject* AddRef(){if(p) Py_INCREF(p); return p;};
		void Release(){if(p) Py_DECREF(p); p=NULL;};
		PyObject* operator->(){return p;};
		bool is() {return p? true : false;};
		operator PyObject*(){return p;};
		PyObject* operator=(PyObject* pythonObject){p=pythonObject; return p;};
		operator bool(){return p? true : false;};
};

#endif//PYTHON_CPP_H
