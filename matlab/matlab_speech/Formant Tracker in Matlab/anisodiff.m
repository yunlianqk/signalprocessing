% ANISODIFF - Anisotropic diffusion.
%
% Usage:
%  diff = anisodiff(im, niterations, kappa, lambda, option)
%
%         im  - input image
%         nititerations 
%         kappa - conduction coefficient 20-100 ?
%         lambda - max value of .25 for stability
%         option - 1 Perona Malik diffusion equation No 1
%                  2 Perona Malik diffusion equation No 2
%
% Reference: 
% P. Perona and J. Malik. 
% Scale-space and edge detection using ansotropic diffusion.
% IEEE Transactions on Pattern Analysis and Machine Intelligence, 
% 12(7):629-639, July 1990.
%
% Author: Peter Kovesi   pk@cs.uwa.edu.au
% Department of Computer Science & Software Engineering
% The University of Western Australia
%
% June 2000         

function diff = anisodiff2(im, niterations, kappa, lambda, option)

im = double(im);
[rows,cols] = size(im);
diff = im;
  
for i = 1:niterations
  fprintf('\rIteration %d',i);

  % Construct diffl which is the same as diff but
  % has an extra padding of zeros around it.
  diffl = zeros(rows+2, cols+2);
  diffl(2:rows+1, 2:cols+1) = diff;

  % North, South, East and West differences
  deltaN = diffl(1:rows,2:cols+1) - diff;
  deltaS = diffl(3:rows+2,2:cols+1) - diff;
  deltaE = diffl(2:rows+1,3:cols+2) - diff;
  deltaW = diffl(2:rows+1,1:cols) - diff;

  % Conduction

  if option == 1

    cN = exp(-(deltaN/kappa).^2);
    cS = exp(-(deltaS/kappa).^2);
    cE = exp(-(deltaE/kappa).^2);
    cW = exp(-(deltaW/kappa).^2);

  elseif option == 2

    cN = 1./(1+exp(-(deltaN/kappa).^2));
    cS = 1./(1+exp(-(deltaS/kappa).^2));
    cE = 1./(1+exp(-(deltaE/kappa).^2));
    cW = 1./(1+exp(-(deltaW/kappa).^2));
  end


  diff = diff + lambda*(cN.*deltaN + cS.*deltaS + cE.*deltaE + cW.*deltaW);

%  Uncomment the following to see a progression of images
%  subplot(ceil(sqrt(niterations)),ceil(sqrt(niterations)), i)
%  imagesc(diff), colormap(gray), axis image

end
fprintf('\n');

