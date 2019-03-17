 function [data] = run_measurement_generator(var, user, data, sys, pf)

%--------------------------------------------------------------------------
% Builds measurement data.

% The function corrupts the exact solutions from power flow analysis by the
% additive white Gaussian noises according to defined variances. Further,
% the function forms measurement set according to predefined inputs.
%--------------------------------------------------------------------------
%  Inputs:
%	- user: user inputs
%	- data: input power system data
%	- sys: power system data
%	- pf: power flow data
%--------------------------------------------------------------------------
%  Outputs:
%	- data: with additional struct variables:
%	  - data.legacy.flow: power flow measurements with columns:
%		(1)indexes from bus; (2)indexes to bus;
%		(3)active power flow measurements;
%		(4)active power flow measurement variances;
%		(5)active power flow measurements turn on/off;
%		(6)reactive power flow measurements;
%		(7)reactive power flow measurement variances;
%		(8)reactive power flow measurement turn on/off;
%		(9)active power flow exact value;
%		(10)reactive power flow exact value;
%	  - data.legacy.current: current magnitude measurements with columns:
%		(1)indexes from bus; (2)indexes to bus;
%		(3)line current magnitude measurements;
%		(4)line current magnitude measurement variances;
%		(5)line current magnitude measurement turn on/off;
%		(6)line current magnitude exact value;
%	  - data.legacy.injection: power injection measurements with columns:
%		(1)bus indexes; (2)active power injection measurements;
%		(3)active power injection measurement variances;
%		(4)active power injection measurements turn on/off;
%		(5)reactive power injection measurements;
%		(6)reactive power injection measurement variances;
%		(7)reactive power injection measurements turn on/off;
%		(9)active power injection exact value;
%		(10)reactive power injection exact value;
%	  - data.legacy.voltage: voltage magnitude measurements with columns:
%		(1)bus indexes; (2)bus voltage magnitude measurements;
%		(3)bus voltage magnitude measurement variances;
%		(4)bus voltage magnitude measurements turn on/off;
%		(5)bus voltage magnitude exact value;
%	  - data.pmu.current: phasor current measurements with columns:
%		(1)indexes from bus; (2)indexes to bus;
%		(3)line current magnitude measurements;
%		(4)line current magnitude measurement variances;
%		(5)line current magnitude measurements turn on/off;
%		(6)line current angle measurements;
%		(7)line current angle measurement variances;
%		(8)line current angle measurements turn on/off;
%		(9)line current magnitude exact value;
%		(10)line current angle exact value;
%	  - data.pmu.voltage: phasor voltage measurements with columns:
%		(1)bus indexes; (2)bus voltage magnitude measurements;
%		(3)bus voltage magnitude measurement variances;
%		(4)bus voltage magnitude measurements turn on/off;
%		(5)bus voltage angle measurements;
%		(6)bus voltage angle measurement variances;
%		(7)bus voltage angle measurements turn on/off;
%		(8)bus voltage magnitude exact value;
%		(9)bus voltage angle exact value;
%--------------------------------------------------------------------------
% The local function which is used to generate measurements.
%--------------------------------------------------------------------------


%--------------------------Measurement Generator---------------------------
 [msr]  = variable_device(sys); 

 if user.method == 2 
   [user] = measurement_variance_options(var, user);
   [msr]  = variance_produce(user, msr);
   [data] = export_measurement(data, user, sys, msr, pf);
 end
 
 [user] = measurement_set_options(var, user, msr); 
 [msr]  = set_produce(user, msr, sys);
 [data] = export_set(user, data, sys, msr);

 [data] = export_info(data, user, msr);
%--------------------------------------------------------------------------