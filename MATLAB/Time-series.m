beta = 0.99;  % AR coefficient
numSamples = 100;  % Number of time series to generate

% --- Function to generate AR(1) data, estimate coefficients, and analyze results ---
function analyzeARprocess(beta, numSamples, sampleLength)

  % Pre-allocate a matrix to store the time series data
  data = zeros(sampleLength, numSamples); 

  for i = 1:numSamples
      e = randn(sampleLength, 1);  % Generate white noise
      y = zeros(sampleLength, 1); 
      y(1) = 0;  % Initial value

      % Generate the AR(1) process
      for t = 2:sampleLength
          y(t) = beta * y(t-1) + e(t); 
      end

      data(:, i) = y; 
  end

  estimatedCoefficients = zeros(numSamples, 1); 

  for i = 1:numSamples
      y = data(:, i); 
      X = y(1:end-1);  
      y = y(2:end);   
      
      % Use the 'regress' function to estimate the coefficient
      b = regress(y, X);  
      estimatedCoefficients(i) = b(1); 
  end

  % Plot a histogram of the estimated coefficients
  histogram(estimatedCoefficients)
  xlabel('Estimated AR Coefficient')
  ylabel('Frequency')
  title(['Histogram of Estimated AR Coefficients (Sample Length = ', num2str(sampleLength), ')'])

  % Calculate the share of estimates below 0.95
  shareBelow095 = sum(estimatedCoefficients < 0.95) / numSamples;
  fprintf('Share of estimates below 0.95: %.2f\n', shareBelow095);

  % Count the number of estimates above 1
  numAbove1 = sum(estimatedCoefficients > 1);
  fprintf('Number of estimates above 1: %d\n', numAbove1);

end

% --- Run the analysis with different sample lengths ---
analyzeARprocess(beta, numSamples, 50);  % Analysis with sampleLength = 50
figure; % Create a new figure for the next histogram
analyzeARprocess(beta, numSamples, 1000); % Analysis with sampleLength = 1000