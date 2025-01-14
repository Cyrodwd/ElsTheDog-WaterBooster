module scenes.iscene;

interface IScene
{
    /// Called once at the first frame
    void onStart();
    /// Called each frame
    void onUpdate(float dt);
    /// Called each frame to draw
    void onDraw();
}