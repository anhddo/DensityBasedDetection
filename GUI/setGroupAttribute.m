function groupHandles=setGroupAttribute(groupHandles,attribute,value)
for i=1:numel(groupHandles)
    set(groupHandles(i),attribute,value);
end
end