function first_level_contrast(data_dir, stat, name, vec)
    
    % SPM.mat path
    spmmat_path = fullfile(fileparts(data_dir), 'classical', 'SPM.mat');
    
    %==================CONTRAST ESTIMATION======================
    % specify matlabbatch
    matlabbatch = {};
    matlabbatch{1}.spm.stats.con.spmmat = {spmmat_path};

    % define contrast
    if stat == 't'
        matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = name;
        matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = vec;
        matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    elseif stat == 'f'
        matlabbatch{1}.spm.stats.con.consess{1}.fcon.name = name;
        matlabbatch{1}.spm.stats.con.consess{1}.fcon.weights = vec;
        matlabbatch{1}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
    end
    matlabbatch{1}.spm.stats.con.delete = 1;
    
    % run contrast estimation
    spm_jobman('run', matlabbatch);

    %===================RESULT TABLE====================
    p_value_threshold = 0.05;
    
    matlabbatch{2}.spm.stats.results.spmmat = {spmmat_path};
    matlabbatch{2}.spm.stats.results.conspec(1).titlestr = name;
    matlabbatch{2}.spm.stats.results.conspec(1).contrasts = 1;
    matlabbatch{2}.spm.stats.results.conspec(1).threshdesc = 'FWE'; % 'FWE' for family-wise error correction, 'FDR' for false discovery rate, or 'none'
    matlabbatch{2}.spm.stats.results.conspec(1).thresh = p_value_threshold;
    matlabbatch{2}.spm.stats.results.conspec(1).extent = 0; % minimum cluster size
    matlabbatch{2}.spm.stats.results.conspec(1).conjunction = 1;
    matlabbatch{2}.spm.stats.results.conspec(1).mask.none = 1; % no mask
    
    spm_jobman('run', matlabbatch);
    
end