function [pts] = x_sequence_2D(h_max)
    x_0 = x_sequence(h_max);
    l = length(x_0);
    ctr = 0;
    y_pts = zeros(1, l);
    y_pts(1) = 1;
    updateBound = 1;
    update = 1;
    for t = 1:round(l/2)
        if ctr == 0
            y_pts(2*t) = y_pts(t);
            y_pts(2*t + 1) = y_pts(t);
        else
            y_pts(2*t) = 2*y_pts(t);
            y_pts(2*t + 1) = 2*y_pts(t) + 1;
        end
        if update == updateBound
            ctr = 1 - ctr;
            update = 1;
            updateBound = updateBound*2;
        else 
            update = update + 1;
        end
    end
    
    ctr = 1;
    x_pts = zeros(1, l);
    x_pts(1) = 1;
    updateBound = 1;
    update = 1;
    for t = 1:round(l/2)
        if ctr == 0
            x_pts(2*t) = x_pts(t);
            x_pts(2*t + 1) = x_pts(t);
        else
            x_pts(2*t) = 2*x_pts(t);
            x_pts(2*t + 1) = 2*x_pts(t) + 1;
        end
        if update == updateBound
            ctr = 1 - ctr;
            update = 1;
            updateBound = updateBound*2;
        else 
            update = update + 1;
        end
    end
    
    pts = zeros(2, l);
    pts(1, :) = x_0(x_pts(1:l));
    pts(2, :) = x_0(y_pts(1:l));
end