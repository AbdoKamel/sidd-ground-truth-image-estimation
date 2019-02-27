function [] = prepare_parallel_pool(NUM_WORKERS)
%PREPARE_PARALLEL_POOL Summary of this function goes here
%   Detailed explanation goes here

    po = gcp('nocreate');
    if ~isempty(po)
        if po.NumWorkers ~= NUM_WORKERS
            delete(po);
            pc=parcluster('local');
            pc.NumWorkers=NUM_WORKERS;
            po = parpool(NUM_WORKERS);
        end
    else
        pc=parcluster('local');
        pc.NumWorkers=NUM_WORKERS;
        po = parpool(NUM_WORKERS);
    end
    pctRunOnAll warning off;
    
end

