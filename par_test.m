function par_test()

    dbtype pctdemo_aux_parforbench

    p = gcp;
    if isempty(p)
        error('pctexample:backslashbench:poolClosed', ...
            ['This example requires a parallel pool. ' ...
             'Manually start a pool using the parpool command or set ' ...
             'your parallel preferences to automatically start a pool.']);
    end
    poolSize = p.NumWorkers;

    numHands = 2000;
    numPlayers = 6;
    fprintf('Simulating each player playing %d hands.\n', numHands);
    t1 = zeros(1, poolSize);
    for n = 2:poolSize
        tic;
            pctdemo_aux_parforbench(numHands, n*numPlayers, n);
        t1(n) = toc;
        fprintf('%d workers simulated %d players in %3.2f seconds.\n', ...
                n, n*numPlayers, t1(n));
    end
    
end

function S = pctdemo_aux_parforbench(numHands, numPlayers, n)
    %PCTDEMO_AUX_PARFORBENCH Use parfor to play blackjack.
    %   S = pctdemo_aux_parforbench(numHands, numPlayers, n) plays 
    %   numHands hands of blackjack numPlayers times, and uses no 
    %   more than n MATLAB(R) workers for the computations.

    %   Copyright 2007-2009 The MathWorks, Inc.

    S = zeros(numHands, numPlayers);
    parfor (i = 1:numPlayers, n)
        S(:, i) = pctdemo_task_blackjack(numHands, 1);
    end

end