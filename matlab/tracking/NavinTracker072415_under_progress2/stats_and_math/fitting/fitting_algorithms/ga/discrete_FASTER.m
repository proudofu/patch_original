function [m, bestscore] = discrete_FASTER(varargin)

[funfcn, tol, display_flag, m_choice, m_length, m1] = parse_inputs_discrete_optimization(varargin);


bestscore = 1e10;
if(~isempty(m1))
    m = m1;
else
    for(p=1:m_length)
        m_current=[];
        for(i=1:m_length)
            m_current(i) = m_choice{i}(randint(length(m_choice{i})));
        end
        score = funfcn(m_current);
        if(score<bestscore)
            bestscore = score;
            m = m_current;
            if(display_flag==1)
                disp([num2str(p) ' ' num2str(bestscore) ' ' timeString ' ' num2str(m)])
            end
        end
    end
end
bestscore = funfcn(m);

func_eval = 0;
stopflag=0;
cyc_num=0;
while(stopflag==0)
    stopflag = 1;
    cyc_num = cyc_num+1;
    
    idx = randint(m_length,m_length);
    while(~isempty(idx))
        n = idx(end); % pick a random bit position
        
        % go through all allowed bits at that position
        allowed_vals = m_choice{n};
        for(i=1:length(allowed_vals))
            
            
            idx_p = randint(m_length,m_length);
            idx_p(idx_p==n)=[];
            
            while(~isempty(idx_p))  % go through all other bit positions
                p = idx_p(end);
                
                allowed_vals_p = m_choice{p};
                
                for(j=1:length(allowed_vals_p))
                    
                    m_current = m;
                    m_current(n) = allowed_vals(i);
                    m_current(p) = allowed_vals_p(j);
                    
                    score = funfcn(m_current); func_eval = func_eval+1;
                    if(score<bestscore)
                        stopflag=0;
                        m = m_current;
                        bestscore = score;
                        if(display_flag==1)
                            disp([num2str(cyc_num) ' ' num2str([n i]) ' ' num2str([p j]) ' ' num2str(func_eval) ' ' num2str(bestscore) ' ' timeString ' ' num2str(m)])
                        end
                    end
                end
                
                idx_p(end)=[];
            end
        end
        
        idx(end)=[];
    end
    
end

return;
end

