% THIS SCRIPT INITIALIZES SIGNALS FOR A DEMO SIMULATION
%====================================================================

classdef DemoSignals
    
    % Properties    
    properties
        inputs
        disturbances
        faults
    end
    
    
    % Methods    
    methods
       
        function obj= DemoSignals(...
            m, mag_min, mag_max, n_d, n_f, stair_int, sim_end...
            )
            % m- No of input signals
            % mag_min- Min magnitude of input signal
            % mag_max- Max magnitude of input signal
            % n_d- No of disturbance inputs
            % n_f- No of fault inputs
            % stair_int- Interval between stair values
            % sim_end- Simulation end time
            
            sprintf("Creating Demo Signals...")
            
            % INPUTS
            %
            % VECTORS THAT GO INTO A "Repeating Sequence Stair" SIMULINK
            % BLOCK
            %
            % Length of vectors
            m_len= ceil(sim_end/stair_int);
            obj.inputs.signals= randi([mag_min, mag_max], m, m_len);
            % Sample Time
            obj.inputs.k= stair_int; 
            
            
            % DISTURBANCES
            % 
            % INITIALIZATION VALUES FOR A SIMULINK "Band-Limited White
            % Noise" BLOCKS
            %
            % Noise Power
            obj.disturbances.n_powers= 0.001.*rand(n_d, 1);
            % Sample Time
            obj.disturbances.k= 0.1;
            % Seed
            obj.disturbances.seeds= randi([0, 99999], n_d, 1);
            
            
            % FAULTS
            %
            % INITIALIZATION VALUES FOR "Step" SIMULINK BLOCKS
            %
            % Fault Amplitude
            obj.faults.amp= 5;
            % Fault Times
            obj.faults.times= randi([0, (sim_end-5)], n_f, 1);          
            
            obj
            
            sprintf("Demo Signals Created")
            
        end
        
    end
    
end