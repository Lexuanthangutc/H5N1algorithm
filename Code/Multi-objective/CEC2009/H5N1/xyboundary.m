%==========================================================================
%  CEC2009 test problems
%
%  Developer : Le Xuan Thang
%
%  email: lxt1021997lxt@gmail.com
%
%==========================================================================

function [x,y] = xyboundary(name,Archive_member_no)    

    switch name
        case{'UF5'}
            N = 10;  % Số lượng khoảng
            d = 2;  % Số lượng phần tử trong mỗi nửa khoảng
            
            x = linspace(0, 1, N+1);  % Tạo N+1 điểm chia khoảng
            
            x_values = [];  % Mảng chứa kết quả
            
            for i = 1:N
                x_range = linspace(x(i), x(i+1), d+1);  % Tạo d+1 giá trị trong khoảng
                x_values = [x_values x_range(1:end-1) x_range(end)];  % Thêm các giá trị vào mảng kết quả
            end

            x = x_values;

            y = linspace(0,1,Archive_member_no);
        case{'UF6'}
            x = linspace(0,1,Archive_member_no);
            x1 = x(1);
            x2 = x(2);
            x(1:Archive_member_no/4-1) = 0; 
            x(Archive_member_no/4) = x(Archive_member_no/4) + x2-x1;
            x(2*Archive_member_no/4+1: 3*Archive_member_no/4-1) = 0.5;
            x(3*Archive_member_no/4) = x(Archive_member_no/4) + x2-x1;
            y = linspace(0,1,Archive_member_no);
        case {'UF9'}
            Archive_member_no = 100;  % Số lượng phần tử mong muốn
            
            % Tạo tập hợp x1 từ khoảng [0, 0.25]
            x1a = linspace(0, 0.25, Archive_member_no/2);
            
            % Tạo tập hợp x1 từ khoảng [0.75, 1]
            x1b = linspace(0.75, 1, Archive_member_no/2);
            
            % Kết hợp các tập hợp lại thành một tập hợp duy nhất x1
            x = [x1a x1b];
            y = linspace(0,1,Archive_member_no);
        otherwise
            x = linspace(0,1,Archive_member_no);
            y = linspace(0,1,Archive_member_no);
    end
end