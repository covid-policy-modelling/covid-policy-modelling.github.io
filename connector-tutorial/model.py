#! /usr/bin/env python3
import numpy as np
from scipy.integrate import solve_ivp
from scipy.interpolate import InterpolatedUnivariateSpline

# Model definition
def model(t, u, p):
    b,g = p
    S,I,R = u
    dS = -b*S*I
    dI = b*S*I-g*I
    dR = g*I
    return [dS,dI,dR]

# Stop integration at steady state
# See https://scicomp.stackexchange.com/questions/16325/dynamically-ending-ode-integration-in-scipy
def steady_state(t,u,p,f,tol):
    global flag
    du = f(t,u,p)
    condition = np.max(np.abs(du))<tol
    if flag == 1:
        if condition:
            test = [0]
        else:
            test = [1]
        flag = 0
    else:
        if condition:
            test = np.array([0])
        else:
            test = np.array([1])
    return test

def simulate(tspan, u0, p):
    # Define terminal condition and type-change flag
    tol = 1e-6
    limit = lambda t, u: steady_state(t,u,p,model,tol)
    limit.terminal = True
    global flag

    flag = 1

    # Run model
    sol = solve_ivp(lambda t, u: model(t, u, p),
                    tspan,
                    u0,
                    events = limit)

    # Generate outputs
    ## Final size
    fs = sol.y[2,-1]
    ## Peak infected and peak time
    f = InterpolatedUnivariateSpline(sol.t, sol.y[1,:], k=4)
    cr_pts = f.derivative().roots()
    cr_pts = np.append(cr_pts, (sol.t[0], sol.t[-1]))  # also check the endpoints of the interval
    cr_vals = f(cr_pts)
    max_index = np.argmax(cr_vals)
    pk = cr_vals[max_index]
    pkt = cr_pts[max_index]

    # Extract outputs
    return {"t": sol.t.tolist(), "u": sol.y.tolist(), "outputs":[fs, pk, pkt]}
