% Created: Prateek Prasanna
% Updated: Ahmad Algohary    08/12/2017

function [dominant_orientation_roi]=find_orientation_CoLlAGe(Fx_o, Fy_o, k, r, c)

    I_gradient_inner=zeros(size(Fx_o, 1), size(Fx_o, 1));

    for i = k+1:k+r
        for j = k+1:k+c
            G = [];
            for a = i-k : i+k
                for b = j-k : j+k
                    G = [G; [Fx_o(a,b), Fy_o(a,b)]];
                end
            end

%             if(i == 2 + 1 && j == 7 + 1) % Testing
%                 x = 0;
%             end
            
            V = ComputeV(G);
            I_gradient_inner(i,j) = Atan_2(V(1,1), V(2,1));  %Find dominant direction
        end
    end

    dominant_orientation_roi = I_gradient_inner(k+1 : k+r, k+1 : k+c);

end

