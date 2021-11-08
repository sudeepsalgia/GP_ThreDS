function [pts] = x_sequence_nd(d, h_max)
    x_0 = x_sequence(h_max);
    len = length(x_0);
    pts = zeros(d, len);
    pts(:, 1) = 0.5*ones(d, 1);
    split_idxs = zeros(1, len);
    split_idxs(1) = 1;
    for i = 1:floor(len/2)
        idx_val = mod(split_idxs(i), d) + 1;
        split_idxs(2*i) = idx_val;
        split_idxs(2*i + 1) = idx_val;
    end
    for i = 1:floor(len/2)
        upd_idx = 2*i;
        seq_idx_upd = split_idxs(upd_idx);
        curr_val = pts(seq_idx_upd, i);
        curr_1d_seq_val = find(x_0 == curr_val);
        pt_vec = pts(:, i);
        pt_vec(seq_idx_upd) = x_0(2*curr_1d_seq_val);
        pts(:, upd_idx) = pt_vec;
        
        upd_idx = 2*i + 1;
        seq_idx_upd = split_idxs(upd_idx);
        curr_val = pts(seq_idx_upd, i);
        curr_1d_seq_val = find(x_0 == curr_val);
        pt_vec = pts(:, i);
        pt_vec(seq_idx_upd) = x_0(2*curr_1d_seq_val + 1);
        pts(:, upd_idx) = pt_vec;
    end
    
    
end