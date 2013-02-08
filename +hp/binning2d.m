function y=binning2d(x1,x2,nx)

% returns binning values


%obtain phase angle time series

  theta1=angle(x1)+pi; %angles in the range [0 2pi]
  theta2=angle(x2)+pi;
  
  binned1=ceil(theta1/(2*pi/nx));
  binned2=ceil(theta2/(2*pi/nx));
  
  
  y = crosstab(binned1,binned2)/(length(theta1));
  