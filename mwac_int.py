#File name:		mwac_int.py
#Description:		Integrates horizontal flux from mwac network site mwac samplers
#Author:		Brandon Edwards
#Created on:		19 February 2018 14:03:18
#Version:		1
#Python version:	3.6
#======================================================================

import sys
import argparse
import numpy as np
import scipy as sc
from scipy.integrate import quad
import lmfit
from lmfit import Model


def three_param_model(x,A,B,C):
    return(A*np.exp(B*x + C*x**2))
    

def two_param_model(x,A,B):
    return(A*np.exp(-B*x))
    

three_model=Model(three_param_model)
two_model=Model(two_param_model)


def build_test_sequence(infilename, int_min, int_max,
                        opening_size):
    infile=open(infilename)
    inputs=infile.read()
    infile.close()

    test_sequence=[]
    sequence=[i.strip() for i in inputs.split("\n999\n")]
    for test in sequence:
        test_name=[]
        test_days=[]
        heights=[]
        masses=[]
        lines=[t.strip() for t in test.split("\n")]
        if not lines:
            continue
        for line in lines:
            values=[l.strip() for l in line.split()]
            if len(values) == 0: continue
            if len(values) == 2:
                height, mass = values
            elif len(values) == 4:
                assert len(values) == 4
                name, height, mass, days = values
                test_name.append(name)
                test_days.append(days)
            else:
                print ("***ERROR*** error in values '{}'".format(line))
                continue
            heights.append(float(height))
            masses.append(float(mass))
        assert len(test_name) == 1, "test_name={}".format(test_name)
        assert len(test_days) == 1, "test_days={}".format(test_days)
        test_sequence.append(
                    {"name": test_name[0],
                     "days": test_days[0],
                     "heights": heights,
                     "masses": masses,
                     "int_max": int_max,
                     "int_min": int_min,
                     "opening_size": opening_size,
                     "result": None,
                    })
    return test_sequence

def mwac_solve(test):
   
    int_min=test['int_min']
    int_max=test['int_max']
    heights=test['heights']
    fluxes=np.divide(np.divide(test['masses'],float(test['days'])),test['opening_size'])

    if len(heights)==3:
        result = two_model.fit(fluxes, A=5, B=1, x=heights)
        a=result.best_values['A']
        b=result.best_values['B']
        flux_int=quad(two_param_model,int_min,int_max,args=(a,b))
    elif len(heights)==4:
        result = three_model.fit(fluxes, A=5, B=1, C=1, x=heights)
        c=result.best_values['A']
        d=result.best_values['B']
        e=result.best_values['C']
        flux_int=quad(three_param_model,int_min,int_max,args=(c,d,e)) 
    else:
        raise RuntimeError("blah blah")

    
   
    test['flux']=flux_int[0]
    test['parameters']=result.best_values
    test['Rsq']=1-result.residual.var()/np.var(fluxes)
    
    return


def run_test_sequence(test_sequence):
    for test in test_sequence:
        mwac_solve(test)
    return test_sequence

def generate_output(test_sequence, outfilenm):
    if outfilenm is None:
        outfile = sys.stdout
    else:
        outfile = open(outfilenm, "w")

    outfile.write("{:12}  {:10}  {:8}  {}\n"
                .format('Test name,','total flux,', 'R^2,', 'Parameters'))
    last_name = test_sequence[0]['name']
    for test in test_sequence:
        name = test['name']
        if name != last_name:
            outfile.write('\n')
            last_name = name
        
        outfile.write("{:12}  {:10.6}  {:8.6} {}\n"
                    .format(name, test['flux'], test['Rsq'], test['parameters']))


def main():
    parser = argparse.ArgumentParser(description='Run mwac flux model.')
    parser.add_argument('-i', dest='infilename', action='store',
                        metavar='INPUT_FILE',
                        help='Name of the input file (default: stdin)')
    parser.add_argument('-o', dest='outfilenm', action='store',
                        metavar='OUTPUT_FILE',
                        help='Name of the output file (default: stdout)')
   
    parser.add_argument('--int_min', metavar='INT.START',
                        type=float,
                        default=0.,
                        help="The integration starting height.  "
                             "Optional, default in 0.")
    parser.add_argument('int_max', metavar='HEIGHT', type=float,
                        help="The integration height parameter")
    parser.add_argument('opening_size', metavar='SIZE', type=float,
                        help="The 'opening_size' parameter")

    args = parser.parse_args()
    
 

    test_sequence = build_test_sequence(args.infilename,
                                        args.int_min,
                                        args.int_max,
                                        args.opening_size)
    run_test_sequence(test_sequence)
    
    generate_output(test_sequence, args.outfilenm)

if __name__ == "__main__":
    main()
