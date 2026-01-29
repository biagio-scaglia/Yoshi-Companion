import duckdb
import diskcache
from loguru import logger
from sentence_transformers import SentenceTransformer


# Configuration
CACHE_DIR = "./cache"
DB_PATH = "yoshi_brain.duckdb"
EMBEDDING_MODEL_NAME = "all-MiniLM-L6-v2"

# Initialize Cache (for LLM responses or embeddings if needed)
cache = diskcache.Cache(CACHE_DIR)

# Initialize Embedding Model (Lazy load can be better, but simple for now)
logger.info("Loading embedding model...")
embedder = SentenceTransformer(EMBEDDING_MODEL_NAME)


def init_db():
    """Initializes DuckDB for vector storage."""
    con = duckdb.connect(DB_PATH)
    con.execute("INSTALL vss; LOAD vss;")  # Vector Search Extension
    con.execute("INSTALL json; LOAD json;")

    # Create Sequence if not exists
    con.execute("CREATE SEQUENCE IF NOT EXISTS doc_id_seq;")

    # Create table for documents if not exists
    # We store: id, filename, content, embedding (VECTOR(384))
    con.execute("""
        CREATE TABLE IF NOT EXISTS documents (
            id INTEGER PRIMARY KEY DEFAULT nextval('doc_id_seq'),
            filename VARCHAR,
            content VARCHAR,
            embedding FLOAT[384]
        )
    """)
    con.close()
    logger.success("DuckDB initialized!")


def ingest_text(filename: str, text: str):
    """Ingests text into DuckDB with embeddings."""
    con = duckdb.connect(DB_PATH)

    # Simple chunking (can be improved)
    chunks = [text[i : i + 500] for i in range(0, len(text), 500)]

    logger.info(f"Ingesting {len(chunks)} chunks from {filename}...")

    for chunk in chunks:
        embedding = embedder.encode(chunk).tolist()
        con.execute(
            "INSERT INTO documents (filename, content, embedding) VALUES (?, ?, ?)",
            [filename, chunk, embedding],
        )

    con.close()
    logger.success(f"Ingested {filename}")


def search(query: str, limit: int = 3) -> str:
    """Searches relevant context from DuckDB."""
    query_embedding = embedder.encode(query).tolist()

    con = duckdb.connect(DB_PATH)
    # Vector search using array_cosine_similarity or simply order by distance
    try:
        # Note: Syntax depends on DuckDB VSS version.
        # Using a generic approach usually works with VSS loaded.
        results = con.execute(
            """
            SELECT content, array_cosine_similarity(embedding, ?::FLOAT[384]) as score
            FROM documents
            ORDER BY score DESC
            LIMIT ?
        """,
            [query_embedding, limit],
        ).fetchall()

        context = "\n".join([row[0] for row in results])
        return context
    except Exception as e:
        logger.error(f"Search failed: {e}")
        return ""
    finally:
        con.close()
