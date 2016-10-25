#include<bits/stdc++.h>

struct vector 
{
	double v;
	double w;

	vector( double v, double w )
		: v{v}, w{w}
	{ }
};

inline vector operator * ( double h, vector p )
{
	return { h * p.v, h * p.w };
}

inline vector operator + ( vector p1, vector p2 )
{
	return { p1.v + p2.v, p1.w + p2.w };
}

//TASK A
vector rk( std::function<vector( vector ) > f, vector v, double h)
{
	vector k1 = f(v);
	vector k2 = f(v + h*((1./3.)*k1));
	vector k3 = f(v + h*(.25*k1 + .75*k2));
	vector k4 = f(v + h*(.1*k1 + .3*k2 + .6*k3));

	return v + h*((1./3.)*k1 + (1./6.)*k2 + (1./3.)*k3 + (1./6.)*k4);
}

//TASK B
vector rk( std::function<vector( double, vector ) > f, double t, vector v, double h)
{
	double t1 = 1;
	vector k1 = f(t, v);
	double t2 = 1;
	vector k2 = f(t + h*(1./3.)*t1, v + h*((1./3.)*k1));
	double t3 = 1;
	vector k3 = f(t + h*(.25*t1 + .75*t2), v + h*(.25*k1 + .75*k2));
	double t4 = 1;
	vector k4 = f(t + h*(.1*t1 + .3*t2 + .6*t3), v + h*(.1*k1 + .3*k2 + .6*k3));

	return v + h*((1./3.)*k1 + (1./6.)*k2 + (1./3.)*k3 + (1./6.)*k4);
}

//TASK C
vector rk41( std::function<vector( double, vector ) > f, double t, vector v, double h)
{
	double t1 = 1;
	vector k1 = f(t, v);
	double t2 = 1;
	vector k2 = f(t + h*.5*t1, v + h*(.5*k1));
	double t3 = 1;
	vector k3 = f(t + h*(0.*t1 + .5*t2), v + h*(0.*k1 + .5*k2));
	double t4 = 1;
	vector k4 = f(t + h*(0.*t1 + .0*t2 + 1.*t3), v + h*(0.*k1 + 0.*k2 + 1.*k3));

	return v + h*((1./6.)*k1 + (1./3.)*k2 + (1./3.)*k3 + (1./6.)*k4);
}
