
Foo = { n=0 }

function Foo.new(cls, Nval)
    self = { n=Nval }
    setmetatable(self, cls)
    cls.__index = cls
    return self
end

setmetatable(Foo, {__call=Foo.new})

function Foo:print()
    print(self.n)
end


