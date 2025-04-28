clear;
close all;
restoredefaultpath;
addpath(genpath(pwd));
addpath('problems');

fprintf('Starting Rosenbrock optimization with Modified Newton method...\n');

% Get Rosenbrock problem information
% P7 is Rosenbrock_2 and P8 is Rosenbrock_100 based on your second code snippet
problem_id = 7 % Use 7 for Rosenbrock_2 or 8 for Rosenbrock_100
problem_info = Setproblems(problem_id);
problem_name = problem_info.name;

fprintf('Running optimization for %s problem\n', problem_name);

% Create a wrapped problem structure with counters
wrapped_problem = create_counting_problem(problem_info);

% Reset global counters
global FUNC_COUNT GRAD_COUNT HESS_COUNT;
FUNC_COUNT = 0;
GRAD_COUNT = 0;
HESS_COUNT = 0;

% Set options for Modified Newton with Wolfe
options = struct();
options.alpha = 0.3;
options.tau = 0.5;
options.c1 = 1e-4;
options.c2 = 0.9;
options.beta = 1e-6;
options.max_ls_iters = 1000;
options.max_iter = 1000;
options.tol = 1e-6;

% Alternatively, if you have a Setoptions function:
% options = Setoptions(1); % Assuming 1 is the index for Modified Newton with Wolfe

% Run Modified Newton with Wolfe
    tic;
    [x_final, f_final, iteration_count, f_history, grad_norm_history] = Modified_Newton_with_Wolfe(wrapped_problem, options);
    runtime = toc;
    
    % Display results
    fprintf('\nResults for %s using Modified Newton with Wolfe:\n', problem_name);
    fprintf('Final function value: %e\n', f_final);
    fprintf('Number of iterations: %d\n', iteration_count);
    fprintf('Number of function evaluations: %d\n', FUNC_COUNT);
    fprintf('Number of gradient evaluations: %d\n', GRAD_COUNT);
    fprintf('Number of Hessian evaluations: %d\n', HESS_COUNT);
    fprintf('Runtime: %.4f seconds\n', runtime);
    
    % Plot convergence history
    figure;
    
    % Function value history
    subplot(1, 2, 1);
    plot(0:length(f_history)-1, f_history, '-b', 'LineWidth', 2);
    title(['Function Value History - ', strrep(problem_name, '_', ' ')]);
    xlabel('Iteration');
    ylabel('f(x)');
    grid on;
    
    % Gradient norm history
    subplot(1, 2, 2);
    semilogy(0:length(grad_norm_history)-1, grad_norm_history, '-b', 'LineWidth', 2);
    title(['Gradient Norm History - ', strrep(problem_name, '_', ' ')]);
    xlabel('Iteration');
    ylabel('||∇f(x)||');
    grid on;

fprintf('Done!\n');