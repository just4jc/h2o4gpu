function [pogs_time, cvx_time] = huber_fit(m, n, params, comp_cvx)
%HUBER_FIT

if nargin <= 2
  params = [];
  params.rho = 1e2;
end
if nargin <= 3
  comp_cvx = false;
  cvx_time = nan;
end

% Generate data.
rng(0, 'twister');

A = randn(m, n);
p = rand(m, 1);
b = randn(m, 1) .* (p <= 0.95) + 10 * rand(m, 1) .* (p > 0.95);

f.h = kHuber;
f.b = b;
g.h = kZero;

% Solve with pogs
A = single(A);
tic
pogs(A, f, g, params);
pogs_time = toc;

% Solve with CVX
if comp_cvx
  tic
  cvx_begin
    variables x(n)
    minimize(sum(huber(A * x - b)))
  cvx_end
  cvx_time = toc;
end

end
