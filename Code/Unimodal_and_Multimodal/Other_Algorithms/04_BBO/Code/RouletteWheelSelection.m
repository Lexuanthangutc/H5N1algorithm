% Le Xuan Thang
% 26/05/2022

function choice=RouletteWheelSelection(P)

accumulation = cumsum(P);
p = rand() * accumulation(end);
chosen_index = -1;
for index = 1 : length(accumulation)
    if (accumulation(index) > p)
        chosen_index = index;
        break;
    end
end
if chosen_index == - 1
    chosen_index = randi([1 length(P)]);
end
choice = chosen_index;

end