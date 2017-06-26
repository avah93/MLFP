classdef FilterBank <handle
    
    properties(Constant)
        CREATE_CROSSPRODUCT = 'crossProduct' %for every point for every scale...
        CREATE_SEQUENTIAL = 'sequential' %all vals who has index i ->one filter
    end
        
    properties(Access = 'public')
        MatrixSize = 26; %always scalar!
        
		Scales = 5;
% 		Orientations = [0 , 0.1745 ,0.3491 ,0.5236 ,0.6981 ,0.8727 , 1.0472 ,1.2217 ,1.3963 ,1.5708 ,1.7453 ,1.9199 ,2.0944 ,2.2689 ,2.4435 ,2.6180 ,2.7925 ,2.9671 ,3.1416 ,3.3161 ,3.4907 ,3.6652 ,3.8397 ,4.0143 ,4.1888 ,4.3633 ,4.5379 ,4.7124 ,4.8869 ,5.0615 ,5.2360 ,5.4105 ,5.5851 ,5.7596 ,5.9341 ,6.1087];
        Orientations = [0 , 0.1745 ,0.3491 ,0.5236 ,0.6981 ,0.8727 , 1.0472 ,1.2217 ,1.3963 ,1.5708 ,1.7453 ,1.9199 ,2.0944 ,2.2689 ,2.4435 ,2.6180 ,2.7925 ,2.9671];
        Frequencies = 2;
        
        CenterPoints = [13 13]; %int type (eg. [5 5; 13 13])
        
        CreateMethod = FilterBank.CREATE_CROSSPRODUCT;
    end
 
    properties(Access = 'public')
        FiltersParams,
		FiltersValues
    end
    
    methods
        function this = FilterBank()           
        end
    end
    
    methods(Access = 'public')
             
        function CreateFilterBank(this, createMethod)
           %createMethod - CREATE_CROSSPRODUCT or CREATE_SEQUENTIAL
            
		   if ~exist('createMethod', 'var') || isempty(createMethod)
		     createMethod = FilterBank.CREATE_CROSSPRODUCT;
		   end
		   
           if lower(createMethod) == lower(FilterBank.CREATE_CROSSPRODUCT)
		       this.CreateMethod = FilterBank.CREATE_CROSSPRODUCT;
               [filtersParams, filtersValues] = CreateCrossProductBank(this);
           else
		       this.CreateMethod = FilterBank.CREATE_SEQUENTIAL;
               [filtersParams, filtersValues] = CreateSequentialBank(this);
           end
           
           this.FiltersParams = filtersParams;
           this.FiltersValues = filtersValues;
           
        end
        
        function ShowFilters(this, featureExtractionFunction, displayFunction)
            %featureExtractionFunction - function to modify cmplx
                 %vals(output) (can return a matrix or scalar)
            %displayFunction - function that show vals (eg. imshow)
            
			if ~exist('featureExtractionFunction', 'var') || isempty(featureExtractionFunction)
				featureExtractionFunction = @(x) GaborKernel.GetRealParts(x);
			end
			
			if ~exist('displayFunction', 'var') || isempty(displayFunction)
				displayFunction = @(im) imshow(im, []);
			end
			
            figure('Name', 'Gabor Kernels');
            
            numOfBoxesInRow = ceil( sqrt( length(this.FiltersValues) ) );
            numOfBoxesInCol = ceil(length(this.FiltersValues) / numOfBoxesInRow);
            
            for idxFilter = 1: length(this.FiltersValues)
                filterParams = this.FiltersParams(idxFilter);
                
                filterValues = this.FiltersValues{idxFilter}; 
                filterValues = featureExtractionFunction(filterValues);
                
                subplot(numOfBoxesInCol, numOfBoxesInRow, idxFilter);
                displayFunction(filterValues);
                title(strcat( num2str(filterParams.Scale), {'; '}, num2str(filterParams.Frequency), {'; '}, num2str(filterParams.Orientation) ));
            end
            
        end
		
		function [filtersParams, responses] = Convolve(this, image, featureExtractionFunction)
            %image - double matrix to covolve with
            %featureExtractionFunction - function to modify cmplx
                 %vals(output) (can return a matrix or scalar)
		
		    if ~exist('featureExtractionFunction', 'var') || isempty(featureExtractionFunction)
				featureExtractionFunction = @(x)GaborKernel.GetAmplitudes(x);
            end
		
			responses = {};
		
			for idxFilter = 1: length(this.FiltersParams)
				filterValues = this.FiltersValues{idxFilter}; 
			 	
                response =  conv2(image, filterValues, 'valid');
				response = featureExtractionFunction(response);
				
				responses = cat(1, responses, response);
			end
		
		    filtersParams = this.FiltersParams;
		end
		
    end
    
    methods(Static, Access = 'public')
   
        function ShowResponses(responses, filtersParams)
            %responses, filterParams - values return by func 'Convolve(...)'
            			
            figure('Name', 'Responses');
            
            numOfBoxesInRow = ceil( sqrt( length(responses) ) );
            numOfBoxesInCol = ceil(length(responses) / numOfBoxesInRow);
            
            for idxResponse = 1: length(responses)
                response = responses{idxResponse};
                
                subplot(numOfBoxesInCol, numOfBoxesInRow, idxResponse);
                imshow(response, []);
            end
            
        end
   
    end   
    
    methods(Access = 'private')
   
        function [filtersParams, filtersValues]  = CreateCrossProductBank(this)
            
		   filtersParams = [];
           filtersValues = {};
            
           for idxPoint = 1:size(this.CenterPoints, 1) 
               
               centerPoint = this.CenterPoints(idxPoint, :);
               
               for scale = this.Scales
                 for orient = this.Orientations
                    for freq = this.Frequencies

                        filter = GaborKernel(this.MatrixSize, scale, orient, freq, centerPoint);
						
						filterParams = struct('CenterPoint', centerPoint, ...
                                      'Scale', scale, 'Orientation', orient, ...
									  'Frequency', freq);
									  
						filtersParams = cat(1, filtersParams, filterParams);						
                        filtersValues = cat(1, filtersValues, filter.KernelValues);
                    end
                 end
              end
           end
           
        end
        
        function [filtersParams, filtersValues]  = CreateSequentialBank(this)
            
           filtersParams = [];
           filtersValues = {};
            
           numOfFilters = size(this.CenterPoints, 1);
           if (numOfFilters ~= size(this.Scales, 1)) || ...
              (numOfFilters ~= size(this.Orientations, 1)) || ...
              (numOfFilters ~= size(this.Frequencies, 1))
          
              error('SequentialBank -> number of values of all parameters must be the same!');
           end
           
           for idx = 1:numOfFilters 
               
               centerPoint = this.CenterPoints(idx, :);
               scale = this.Scales(idx);
               orient = this.Orientations(idx);
               freq = this.Frequencies(idx);
               
               filter = GaborKernel(this.MatrixSize, scale, orient, freq, centerPoint);
               
			   filterParams = struct('CenterPoint', centerPoint, ...
                                     'Scale', scale, 'Orientation', orient, ...
									 'Frequency', freq);
									  
		       filtersParams = cat(1, filtersParams, filterParams);						
               filtersValues = cat(1, filtersValues, filter.KernelValues);			   
           end         
        end
        
    end
end