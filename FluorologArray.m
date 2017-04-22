classdef FluorologArray < handle
    
    properties
        
        wl
        signal
        conc
        
        unbounds
        bounds
        
    end
    
    methods
        
        function this = FluorologArray(wl, ubnd, bnd)
            
            this.wl = wl;
            this.unbounds = ubnd;
            this.bounds = bnd;
            
        end
        
        function addUnbound(this, ubnd)
            
            this.unbounds = [this.unbounds, ubnd];
            
        end
        
        function addBound(this, bnd)
            
            this.bounds = [this.bounds, bnd];
            
        end
        
        function unbound = unbound(this)
            
            unbound = mean(this.unbounds, 2);
            
        end
        
        function bound = bound(this)
            
            bound = mean(this.unbounds, 2);
            
        end
        
    end
    
    methods (Static)
        
        function overlay(varargin)
            
            
            
        end
        
    end
    
end