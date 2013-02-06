classdef StimGen
    properties(Constant)
        RGB=struct('R', 1, 'G', 2,'B', 3);
    end
    
    properties (Hidden)
        colorLevels
        yblk
    end
    
    properties
        StimStruc
        StimSequence
        RedSequence
        Color
    end
    
    methods
        %Constructor
        function SG = StimGen(InitialStim,InitialSequence,colo)
            SG.Color=colo+1;
            SG.StimStruc = InitialStim;
            SG.StimSequence = InitialSequence;
            
            %        SG.RedSequence=gen_red_bar_sequence(InitialStim,InitialSequence);
            % SG.yblk=generate_RGB_rectangle_image(InitialStim.sizeout-InitialStim.h_red,InitialStim.sizeout,InitialStim.colout_basal);
            
        end
        
    end % methods
    
    methods (Static)
        out=gen_red_bar_sequence(in)
       
        
        %function y=generate_RGB_rectangle_image(length,width,Col)
        
        
    end
    
    
end  % classdef