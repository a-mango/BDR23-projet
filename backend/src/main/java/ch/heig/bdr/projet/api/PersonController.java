package ch.heig.bdr.projet.api;

import io.javalin.apibuilder.CrudHandler;
import io.javalin.http.Context;
import org.bson.Document;
import org.jetbrains.annotations.NotNull;

import java.util.List;
import java.util.Optional;

/**
 * Comment controller.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Hugo Germano <hugo.germano@heig-vd.ch>
 */
public class PersonController implements CrudHandler {
    /**
     * The blog service.
     */
    private final PersonService commentService;

    /**
     * Constructor.
     *
     * @param commentService The blog service to use.
     */
    public PersonController(PersonService commentService) {
        this.commentService = commentService;
    }

    /**
     * Create a comment.
     *
     * @param ctx Context of the http query.
     */
    @Override
    public void create(@NotNull Context ctx) {
        Person comment = ctx.bodyAsClass(Person.class);
        Optional<Document> createdComment = Optional.ofNullable(commentService.createComment(comment));

        if (createdComment.isPresent()) {
            ctx.status(201);
            ctx.json(createdComment.get());
        } else {
            ctx.status(500);
            ctx.result("Comment creation failed");
        }
    }

    /**
     * Get a single comment.
     *
     * @param ctx Context of the http query.
     * @param id ID of the comment to delete.
     */
    @Override
    public void getOne(@NotNull Context ctx, @NotNull String id) {
        final Document comment = commentService.getCommentById(id);
        if (comment == null) {
            ctx.status(404);
            ctx.result("Blog not found");
            return;
        }
        ctx.status(200);
        ctx.json(comment.toJson());
    }

    /**
     * Get all comments.
     *
     * @param ctx Context of the http query.
     */
    @Override
    public void getAll(@NotNull Context ctx) {
        List<Document> allComments = commentService.getAllComments();
        if (allComments == null || allComments.isEmpty()) {
            ctx.status(404);
            ctx.result("No blogs found");
            return;
        }
        ctx.status(200);
        ctx.json(allComments);
    }

    /**
     * Update a comment.
     *
     * @param ctx Context of the http query.
     * @param id ID of the comment to delete.
     */
    @Override
    public void update(@NotNull Context ctx, @NotNull String id) {
        String commentId = ctx.pathParam("id");
        Person comment = ctx.bodyAsClass(Person.class);

        Document updatedBlog = commentService.updateComment(commentId, comment);
        if (updatedBlog == null) {
            ctx.status(500);
            ctx.result("Blog update failed");
            return;
        }
        ctx.status(200);
        ctx.json(updatedBlog);
    }

    /**
     * Delete a comment.
     *
     * @param ctx Context of the http query.
     * @param id ID of the comment to delete.
     */
    @Override
    public void delete(@NotNull Context ctx, @NotNull String id) {
        Document deletedComment = commentService.deleteComment(id);
        if (deletedComment != null) {
            ctx.status(200);
            ctx.json(deletedComment);
        } else {
            ctx.status(404);
            ctx.result("Blog not found");
        }
    }
}
