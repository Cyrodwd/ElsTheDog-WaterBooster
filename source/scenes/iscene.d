module scenes.iscene;

/// Scene interface (Methods as start, update and draw)
interface IScene
{
    /// Called once at the first frame
    void onStart();
    /// Called each frame
    void onUpdate(float dt);
    /// Called each frame to draw
    void onDraw();
}