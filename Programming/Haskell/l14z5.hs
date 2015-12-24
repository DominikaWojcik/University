import Control.MonadPlus
newtype Monad m => Parser token m value = 
    Parser ([token] -> m ([token], value)

instance Monad (Parser token m) where
    return x = Parser(\ts -> m(ts, x))
    (Parser f) >>= g 

instance MonadPlus (Parser token m) where
    `mzero` = 
