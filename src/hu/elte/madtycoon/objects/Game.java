package hu.elte.madtycoon.objects;

import hu.elte.madtycoon.core.World;
import hu.elte.madtycoon.objects.Entities.Visitor;
import hu.elte.madtycoon.render.AnimatedSprite;
import hu.elte.madtycoon.utils.Vector2F;
import hu.elte.madtycoon.utils.Vector2I;
import hu.elte.madtycoon.utils.exception.GameFullException;
import hu.elte.madtycoon.utils.exception.NoCoverageException;

import java.util.ArrayDeque;
import java.util.Queue;

public abstract class Game extends Building
{

    private final Queue <Visitor> queue;
    private int max;
    private float timer;
    private boolean playing;
    private int useCost;

    public Game(World world, AnimatedSprite sprite, Vector2F position, Vector2I size, int max, int useCost) {
        super(world, sprite, position, size);
        this.queue = new ArrayDeque<Visitor>();
        this.max = max;
        this.useCost = useCost;
        this.playing = false;
    }

    public void setUseCost(int useCost)
    {
        this.useCost = useCost;
    }

    public int getUseCost()
    {
        return useCost;
    }

    protected Visitor[] getPlayers()
    {
        return queue.toArray(new Visitor[max]);
    }

    public void enter(Visitor visitor) throws GameFullException, NoCoverageException
    {
        if(queue.size() >= max) throw new GameFullException();
        if(!visitor.pay(getUseCost())) throw new NoCoverageException();
        queue.add(visitor);
        visitor.setActive(false);
    }

    @Override
    protected void start()
    {
        this.sprite.setState(AnimatedSprite.IDLE);
    }

    @Override
    public void update(float dt)
    {
        super.update(dt);
        timer += dt;

        if(playing)
        {
            if(timer > getPlayPeriod())
            {
                reward();
                reset();
            }
        }
        else
        {
            System.out.println(queue.size());
            if (queue.size() == max)
                gameStart();
        }
    }

    private void reset()
    {
        this.sprite.setState(AnimatedSprite.IDLE);
        this.setOpened(true);
        this.playing = false;
        for(Visitor visitor : queue)
            visitor.setActive(true);
        queue.clear();

    }

    private void gameStart()
    {
        this.sprite.setState(AnimatedSprite.GAME_PLAY);
        this.setOpened(false);
        this.playing = true;
        this.timer = 0F;
        for(Visitor visitor : queue)
            visitor.setActive(false);
    }

    protected abstract void reward();

    protected abstract float getPlayPeriod();

}
